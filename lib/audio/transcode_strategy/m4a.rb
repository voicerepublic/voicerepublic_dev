# will be called like this
#
#     Audio::TranscodeStrategy::M4a.call(talk.recording)
#
module Audio
  module TranscodeStrategy
    class M4a < Base

      EXTENSION = 'm4a'

      def run
        # TODO
        Talk.without_audio_format('m4a').each do |talk|
          next if talk.ends_at < Time.now
          begin
            convert_wav_to_m4a talk
            talk.audio_formats << 'm4a'
            talk.save!
            Rails.logger.info "Talk ##{talk.id} has been " + 
              "converted into audio format 'm4a'"
            
          rescue Exception => e
            Rails.logger.error "Talk ##{talk.id} could not " +
              "be converted into audio format 'm4a': #{e.message}"
          end
        end
      end

      def convert_wav_to_m4a_cmd(talk)
        name = File.basename(talk.recording)
        "avconv -v quiet -y -i #{name}.wav -b:a 64k -strict experimental #{name}.m4a"
      end

    end
  end
end
