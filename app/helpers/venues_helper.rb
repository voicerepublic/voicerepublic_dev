# TODO cleanup! is anything of this used?
module VenuesHelper
  def recording_path(recording)
    "/system/recordings/#{recording}"
  end

  def end_in_milli(venue)
    end_time = venue.start_time.utc + venue.duration.minutes
    diff = end_time - Time.now.utc
    diff < 0 ? 0 : diff * 1000.0
  end

  #TODO replace with cancan
  def can_comment_venue?(venue)
    return false unless user_signed_in?
    venue.users.include?(current_user)
  end

  def talks_partial(collection)
    collection.count > 1 ? 'shared/talk_small_box' : 'shared/talk_medium_box'
  end

  def talkslive_partial(collection)
    collection.count > 2 ? 'shared/talk_small_box' : 'shared/talk_live_box'
  end

  def talks_grid(collection)
    collection.count > 1 ? 'talks-small-block-grid' : 'list-style-type-none'
  end

  def talkslive_grid(collection)
    collection.count > 2 ? 'talks-small-block-grid' : 'list-style-type-none'
  end

  def social_meta_tags_venue
    opts = {}
    opts[:description] = @venue.description.empty? ? @venue.teaser : strip_html(@venue.description)
    opts[:title]       = @venue.title
    opts[:image]       = @venue.image.url
    opts[:keywords]    = @venue.try(:tag_list)
    opts[:author]      = @venue.user.name
    opts[:url]         = venue_url @venue
    opts[:player]      = { embed: false }
    render_social_meta_tags(opts)
  end

end
