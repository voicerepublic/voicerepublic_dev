# TalkAudio objects are data objects. This is where the glue goes that
# connects the business logic of the talk model (app/models/talk) to
# the more generic audio processing stuff (lib/audio).
#
# TalkAudio#process! will kick off the processing og the strategy chain.
#
# Example Strategy Chain
#
#    precursor kluuu_merge trim auphonic
#
# In Detail
#
# * Precursor
#     transcodes all flv files to wav files
#
# * KluuuMerge
#     merges all wav files in one go
#
# * Trim
#     trims the resulting wav file to talk start and end
#
# * Auphonic
#     runs the trimmed wav file thru auphonic and downloads output all
#     output files defined in the preset
#
class TalkAudio < Struct.new(:talk)

  # the content of the journal file might look like this:
  #
  #     publish asdf-1390839394.flv
  #     publish asdf-1390839657.flv
  #     publish asdf-1390898541.flv
  #     publish asdf-1390898704.flv
  #     record_done asdf-1390839394.flv 1390839394
  #     record_done asdf-1390839657.flv 1390839657
  #     record_done asdf-1390898541.flv 1390898541
  #     record_done asdf-1390898704.flv 1390898704
  #
  # then the journal will look like this
  #
  #     {"publish"=>
  #       [["asdf-1390839394.flv"],
  #        ["asdf-1390839657.flv"],
  #        ["asdf-1390898541.flv"],
  #        ["asdf-1390898704.flv"]],
  #       "record_done"=>
  #         [["asdf-1390839394.flv", "1390839394"],
  #          ["asdf-1390839657.flv", "1390839657"],
  #          ["asdf-1390898541.flv", "1390898541"],
  #          ["asdf-1390898704.flv", "1390898704"]]}
  def journal
    return @journal unless @journal.nil?
    check_journal!
    journal = File.read(journal_path)
    @journal = Hash.new { |h, k| h[k] = [] }.tap do |hash|
      journal.split("\n").each do |line|
        _, event, path, args = line.match(/^(\w+) ([.\w-]+) ?(.*)$/).to_a
        hash[event] << [path] + args.split if _
      end
    end
  end

  # TODO: move into a column of model talk, stored as yaml
  def processing_plan
    %w( precursor kluuu_merge trim auphonic )
  end

  def base
    Settings.rtmp.recordings_path
  end

  # the opts are passed to the StrategyRunner, which passes them on to
  # the strategies; in here goes everything the strategies need to know
  def opts
    {
      path:       base,
      name:       talk.id,
      journal:    journal,
      file_start: journal['record_done'].first.last.to_i, # FIXME: sort to make sure
      talk_start: talk.started_at.to_i,
      talk_stop:  talk.ended_at.to_i
    }
  end

  def process!
    runner = StrategyRunner.new(opts)                                 
    processing_plan.each { |name| runner.run(name) }
  end

  def journal_path
    "#{base}/#{talk.id}.journal"
  end

  def check_journal!
    unless File.exist?(journal_path)
      write_fake_journal!(base, talk.id)
      # FIXME dependency on Rails.logger
      Rails.logger.info "Journal not found for Talk ##{talk.id}, " +
        "reconstructed journal."
    end
  end

  def write_fake_journal!(path, name)
    File.open(journal_path, 'w') do |f|
      f.puts fake_journal(path, name)
    end
  end

  # contains implicit knowledge about nameing scheme of files
  #
  # reconstructs a missing journal on the basis of that knowledge
  def fake_journal(path, name)
    flvs = Dir.glob("#{path}/t#{name}-u*.flv").sort
    result = flvs.map do |flv|
      next nil unless File.size(flv) > 0
      _, basename, timestamp = flv.match(/.*\/(.*?(\d+)\.flv)/).to_a
      ['record_done', basename, timestamp] * ' '
    end
    result.compact * "\n"
  end

end
