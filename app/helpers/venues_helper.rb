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
    venue.user_attends?(current_user)
  end
end
