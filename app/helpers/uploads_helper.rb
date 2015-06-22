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
    }
    "init(#{params.to_json})"
  end

end
