# that's how things worked pre-voicerepublic
module Audio
  module MergeStrategy
    class Kluuu < Base

      # this describes the path from journal to final result
      def run
        # step 1
        journal['record_done'].each do |path, timestamp|
          convert_flv_to_wav path.sub('.flv', '')
        end

        # step 2
        merge_wavs File.basename(base), journal['record_done']

        # TODO: cleanup
      end

      def convert_flv_to_wav_cmd(name)
        "avconv -v quiet -y -i #{name}.flv -vn #{name}.wav"
      end

      # streams is a nested array
      #
      #   [[filename, datetimestr], [filename, datetimestr], ...]
      #
      def merge_wavs_cmd(result, streams)
        # parse datetime
        streams = streams.map { |path, time| [path, datetime(time)] }
        # sort by datetime
        streams = streams.sort_by { |_, datetime| datetime }
        # build command
        start_at = streams.first[1]
        sox = "sox -m #{streams.first[0].sub('.flv', '')}.wav"
        streams[1..-1].each do |name, datetime|
          delay = ((datetime - start_at) * 24 * 60 * 60).to_i
          sox << " \"|sox #{name.sub('.flv', '')}.wav -p pad #{delay}\""
        end
        sox << " #{result}.wav"
        sox
      end

    end
  end
end
