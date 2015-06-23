module UploadsHelper

  def init_audio_uploader
    params = {
      uploadUrl: @presigned_s3_post_url,
      key:       SecureRandom.uuid,
      filter:    %w( ogg x-ogg
                     wav x-wav wave x-pn-wav
                     m4a x-m4a
                     mp3 x-mp3 mpeg3 x-mpeg3
                     mpg x-mpegaudio mpeg ) * ' ',
      success:   "SUCCESSCODE",
      safetynetMessage: I18n.t('talks.fields.unprocessed_upload')
    }

    # the success callback sets the talk UUID, so that the backend
    # knows to expect a talk that has an override set.
    success = "$('#talk_user_override_uuid').attr('value', '#{params[:key]}')"

    # serialize to json and replace placeholder with js code
    params = params.to_json.sub('"SUCCESSCODE"', success)

    "init(#{params})"
  end

end
