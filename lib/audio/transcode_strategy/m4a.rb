# will be called like this
#
#     Audio::TranscodeStrategy::M4a.call(talk.recording)
#
module Audio
  module TranscodeStrategy
    class M4a < Base

      EXTENSION = 'm4a'

      def run
        begin
          name = File.basename(base)
          convert_wav_to_m4a name
          logger.info "File #{base} has been " + 
            "converted into audio format 'm4a'"
          [ base, EXTENSION ] * '.'
        rescue Exception => e
          logger.error "File #{base} could not " +
            "be converted into audio format 'm4a': #{e.message}"
        end
      end
      
      def convert_wav_to_m4a_cmd(name)
        "avconv -v quiet -y -i #{name}.wav -b:a 64k -strict experimental #{name}.m4a"
      end

    end
  end
end
