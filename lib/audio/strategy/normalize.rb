# normalize all fragments
#
module Audio
  module Strategy
    class Normalize < Base

      def inputs
        fragments.map { |f| f.first.sub('.flv', '.wav') }
      end

      def run
        normalize_wavs inputs
        outputs
      end

      def outputs
        inputs
      end

      def normalize_wavs_cmd(files)
        raise 'no streams?' if files.empty?
        files.map do |file|
          "sox --norm #{file} norm.wav; mv norm.wav #{file}"
        end.join("\n")
      end

    end
  end
end
