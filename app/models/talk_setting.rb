# TalkSetting objects are data objects, with some logic for reading
# journals and coping with missing journals. TalkSetting is where the
# glue goes that connects the business logic of the talk model
# (app/models/talk) to the more generic audio processing stuff
# (lib/audio). 
class TalkSetting

  attr_accessor :path, :name, :opts, :journal

  # for specs its handy to assume name is 1
  def initialize(path, name=1, opts={})
    self.path = path
    self.name = name
    self.opts = opts

    # this is done on instanciation to be able to
    # rely on `Dir.pwd`
    self.journal = read_journal
  end

  private

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
  def read_journal
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

  def journal_path
    "#{path}/#{name}.journal"
  end

  def check_journal!
    unless File.exist?(journal_path)
      write_fake_journal!
      # FIXME dependency on Rails.logger
      Rails.logger.info "Journal #{journal_path} not found, " +
        "reconstructed."
    end
  end

  def write_fake_journal!
    File.open(journal_path, 'w') do |f|
      f.puts fake_journal
    end
  end

  # contains implicit knowledge about nameing scheme of files
  #
  # reconstructs a missing journal on the basis of that knowledge
  def fake_journal
    flvs = Dir.glob("#{path}/t#{name}-u*.flv").sort
    result = flvs.map do |flv|
      next nil unless File.size(flv) > 0
      _, basename, timestamp = flv.match(/.*\/(.*?(\d+)\.flv)/).to_a
      ['record_done', basename, timestamp] * ' '
    end
    result.compact * "\n"
  end

end

