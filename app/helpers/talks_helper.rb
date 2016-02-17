module TalksHelper

  def social_meta_tags_talk
    author = @talk.series.user.name
    author = @talk.speakers unless @talk.speakers.blank?
    opts = {
      description: @talk.description_as_text.empty? ?
        @talk.teaser : @talk.description_as_text,
      title:    @talk.title,
      image:    "https://#{request.host}#{@talk.flyer.path}",
      keywords: @talk.try(:tag_list),
      author:   author,
      url:      talk_url(@talk),
      player: {
        embed: true,
        url: flash_player_url(@talk)
      }
    }
    render_social_meta_tags(opts)
  end

  def iso8601(datetime)
    datetime.utc.strftime('%Y%m%dT%H%M%SZ')
  end

  def human_count(count)
    number_to_human(count, units: {thousand:"k", million:"M"}, precision: 2)
  end


end
