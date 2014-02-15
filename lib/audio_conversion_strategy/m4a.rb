module AudioConversionStrategy

  class M4a < Base

    def run
      without_audio_format('m4a').each do |talk|
        begin
          convert_wav_to_m4a talk
          talk.audio_formats << 'm4a'
          Rails.logger.info
            "Talk ##{talk.id} has been converted into audio format 'm4a'"
        rescue Exception => e
          Rails.logger.error
            "Talk ##{talk.id} could not be converted into audio format 'm4a': #{e.message}"
        end
      end
    end

    def convert_wav_to_m4a_cmd(talk)
      name = File.basename(talk.recording)
      "avconv -v quiet -y -i #{name}.wav -b:a 64k -strict experimental #{name}.m4a"
    end

  end

end
