module EmbedPlayerHelper

  def background_picture(talk)
    if talk.talk_image_url.present?
      talk.talk_image_url
    else
      'assets/images/defaults/talk-image.jpg'
    end
  end

  # This URL is used to embed a player onto a FB timeline. It is complete with
  # all relevant information: player, styling and media files.
  #
  # FLV Player taken from: http://flv-player.net/
  # FLV Player options: http://flv-player.net/players/maxi/documentation/
  # FLV Player Version: 1.6
  def flash_player_url(talk)
    host        = Settings.root_url + "/"
    base_url    = "flash/flv_player/player_flv_maxi.swf?config="
    config_path = "#{Settings.root_url}/flash/flv_player/flv_config.txt"
    background  = if talk.archived?
                    "&top1=#{CGI.escape(background_picture(talk))}" + "|10|10" +
                    "&autoplay=1" +
                    "&showplayer=always"
                  else
                    '&title=' + I18n.t('flash_player.not_archived_yet')
                  end


    audio_file  = Settings.root_url + talk.media_links['m4a'].to_s

    url = host + base_url + CGI.escape(config_path) +
      background +
      "&" + "flv=#{CGI.escape(audio_file)}"

    url.html_safe
  end

end
