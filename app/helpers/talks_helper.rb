module TalksHelper

  def itunes_duration_format(duration)
    hours = duration/60  
    minutes = duration % 60
    hours > 0 ?  "#{hours}:#{'%02d' % minutes}:00" : "#{'%02d' % minutes}:00"
  end

  def itunes_enclosure_url(talk, type='mp3')
    path = talk.media_links[type.to_s]
    "#{request.protocol}#{request.host_with_port}#{path}"
  end

  # resize to 1400x1400
  def itunes_image_url(image)
    "#{request.protocol}#{request.host_with_port}#{image.thumb('1400x1400#').url}"
  end
end
