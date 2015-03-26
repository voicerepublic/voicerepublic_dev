module TalksHelper

  def social_meta_tags_talk
    opts = {
      description: @talk.description.empty? ?
        @talk.teaser : strip_html(@talk.description),
      title:    @talk.title,
      image:    "https://#{request.host}#{@talk.flyer.path}",
      keywords: @talk.try(:tag_list),
      author:   @talk.speakers || @talk.venue.user.name,
      url:      talk_url(@talk),
      player: {
        embed: true,
        url: flash_player_url(@talk)
      }
    }
    render_social_meta_tags(opts)
  end

end
