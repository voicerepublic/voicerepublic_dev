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
    collection.count > 1 ? 'shared/talk_small_box' : 'shared/talk_live_box'
  end

  def talks_grid(collection)
    collection.count > 1 ? 'talks-small-block-grid' : 'list-style-type-none'
  end
end
