module EmbedPlayerHelper

  def background_picture(talk)
    talk.image.thumb('445x144#nw').url
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
    top1        = background_picture(talk) + "|10|10"

    audio_file  = Settings.root_url + talk.media_links['m4a']

    url = host + base_url + CGI.escape(config_path) +
      "&" + "top1=#{CGI.escape(top1)}" +
      "&" + "flv=#{CGI.escape(audio_file)}"

    url.html_safe
  end

end
