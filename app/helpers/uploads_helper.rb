module UploadsHelper

  def init_audio_uploader
    key = SecureRandom.uuid

    params = {
      uploadUrl: "https://#{Settings.storage.upload_audio}.s3.amazonaws.com",
      key:       key,
      filter:    %w( ogg x-ogg
                     wav x-wav wave x-pn-wav
                     m4a x-m4a
                     mp3 x-mp3 mpeg3 x-mpeg3
                     mpg x-mpegaudio mpeg ) * ' ',
      # `success` will be evaled on complete
      success:   "$('#talk_user_override_uuid').attr('value', '#{key}')",
      safetynetMessage: I18n.t('talks.fields.unprocessed_upload')
    }

    "init(#{params.to_json})"
  end

  def init_slides_uploader
    key = SecureRandom.uuid

    params = {
      uploadUrl: "https://#{Settings.storage.upload_slides}.s3.amazonaws.com",
      key:       key,
      filter:    'pdf',
      # `success` will be evaled on complete
      success:   "$('#talk_slides_uuid').attr('value', '#{key}')",
      safetynetMessage: I18n.t('talks.fields.unprocessed_upload')
    }

    "init(#{params.to_json})"
  end

end
