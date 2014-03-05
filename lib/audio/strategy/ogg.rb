# transcodes the resulting wav file to ogg
#
module Audio
  module Strategy
    class Ogg < Base
      
      def input
        "#{name}.wav"
      end
      
      def run
        convert_wav_to_ogg
        output
      end

      def convert_wav_to_ogg_cmd
        # "avconv -v quiet -y -i #{input} -b:a 64k -strict experimental #{output}"
        "avconv -v quiet -y -i #{input} #{output}"
      end

      def output
        "#{name}.ogg"
      end

    end
  end
end
