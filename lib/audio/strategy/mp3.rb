# transcodes the resulting wav file to mp3
#
module Audio
  module Strategy
    class Mp3 < Base
      
      def input
        "#{name}.wav"
      end
      
      def run
        convert_wav_to_mp3
        output
      end

      def convert_wav_to_mp3_cmd
        # "avconv -v quiet -y -i #{input} -b:a 64k -strict experimental #{output}"
        "avconv -v quiet -y -i #{input} #{output}"
      end

      def output
        "#{name}.mp3"
      end

    end
  end
end
