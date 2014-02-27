# TalkAudio is where the glue goes that
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
# TODO move this back into the model, its not that much anymore
class TalkAudio < Struct.new(:talk)

  # TODO: move into a column of model talk, stored as yaml
  def processing_plan
    %w( precursor kluuu_merge trim auphonic )
  end

  def base
    Settings.rtmp.recordings_path
  end

  # The setting data object is passed to the StrategyRunner, which
  # passes it on to the strategies; in here goes everything the
  # strategies need to know.
  def setting
    opts ={
      file_start: journal['record_done'].first.last.to_i, # FIXME: sort to make sure
      talk_start: talk.started_at.to_i,
      talk_stop:  talk.ended_at.to_i
    }
    TalkSetting.new(base, talk.id, opts)
  end

  def process!
    runner = StrategyRunner.new(setting)
    processing_plan.each { |name| runner.run(name) }
  end

end
