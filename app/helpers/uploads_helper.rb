module UploadsHelper

  def init_audio_uploader
    key = SecureRandom.uuid

    params = {
      uploadUrl: @presigned_s3_post_url,
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

end
