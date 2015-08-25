module UploadsHelper

  def init_audio_uploader
    key = SecureRandom.uuid

    bucket = Settings.storage.upload_audio
    object_path = ''
    expires = 1.day.from_now

    params = {
      uploadUrl: Storage.put_object_url(bucket, object_path, expires),
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

    bucket = Settings.storage.upload_slides
    object_path = ''
    expires = 1.day.from_now

    params = {
      uploadUrl: Storage.put_object_url(bucket, object_path, expires),
      key:       key,
      filter:    'pdf',
      # `success` will be evaled on complete
      success:   "$('#talk_slides_uuid').attr('value', '#{key}')",
      safetynetMessage: I18n.t('talks.fields.unprocessed_upload')
    }

    "init(#{params.to_json})"
  end

end
