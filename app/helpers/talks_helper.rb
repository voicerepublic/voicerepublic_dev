module TalksHelper

  def social_meta_tags_talk
    opts = {}
    opts[:description] = @talk.description.empty? ? @talk.teaser : strip_html(@talk.description)
    opts[:title]       = @talk.title
    opts[:image]       = "https://#{request.host}#{@talk.flyer.path}"
    opts[:keywords]    = @talk.try(:tag_list)
    opts[:author]      = @talk.speakers || @talk.venue.user.name
    opts[:url]         = talk_url @talk
    opts[:player]      = {
                           embed: true,
                           url: flash_player_url(@talk)
                         }
    render_social_meta_tags(opts)
  end

end
