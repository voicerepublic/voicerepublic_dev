require 'date'

# that's how things worked pre-voicerepublic
#
# merges all wav files in one go
#
module Audio
  module Strategy
    class KluuuMerge < Base

      def inputs
        fragments.map { |f| f.first.sub('.flv', '.wav') }
      end

      def run
        merge_wavs(fragments, output)
        output
      end

      def output
        "#{name}.wav"
      end

      # streams is a nested array
      #
      #   [[filename, datetimestr], [filename, datetimestr], ...]
      #
      def merge_wavs_cmd(streams, outfile)
        # parse datetime
        streams = streams.map { |path, time| [path, parse_ts(time)] }
        # sort by datetime
        streams = streams.sort_by { |_, datetime| datetime }
        # build command
        start_at = streams.first[1]
        sox = "sox -m #{streams.first[0].sub('.flv', '')}.wav"
        streams[1..-1].each do |name, datetime|
          delay = ((datetime - start_at) * 24 * 60 * 60).to_i
          sox << " \"|sox #{name.sub('.flv', '')}.wav -p pad #{delay}\""
        end
        sox << " #{outfile}"
      end

      def parse_ts(str)
        ::DateTime.strptime(str, '%s')
      end
      
    end
  end
end
