module UploadsHelper

  def init_audio_uploader
    init_uploader Settings.storage.upload_audio,
                  %w( ogg x-ogg
                      wav x-wav wave x-pn-wav
                      m4a x-m4a
                      mp3 x-mp3 mpeg3 x-mpeg3
                      mpg x-mpegaudio mpeg ) * ' ',
                  "$('#talk_user_override_uuid').attr('value', '%s')"
  end

  def init_slides_uploader
    init_uploader Settings.storage.upload_slides,
                  'pdf',
                  "$('#talk_slides_uuid').attr('value', '%s')"
  end

  private

  def init_uploader(bucket, filter, success_tmpl)
    key = SecureRandom.uuid

    params = {
      uploadUrl: json_proof_presigned_url(bucket, key),
      key:       key,
      filter:    filter,
      # `success` will be evaled on complete
      success:   success_tmpl % key,
      safetynetMessage: I18n.t('talks.fields.unprocessed_upload')
    }

    "init(#{params.to_json})"
  end

  def json_proof_presigned_url(bucket, key)
    expires = 1.day.from_now
    headers = {}
    options = {}
    url = Storage.put_object_url(bucket, key, expires, headers, options)
    base, params = url.split('?')
    base + '?' + CGI.escape(params)
  end

end
