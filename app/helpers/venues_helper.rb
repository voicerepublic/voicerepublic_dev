module VenuesHelper
  def recording_path(recording)
    "/system/recordings/#{recording}"
  end

  def end_in_milli(venue)
    end_time = venue.start_time.utc + venue.duration.minutes
    diff = end_time - Time.now.utc
    diff < 0 ? 0 : diff * 1000.0
  end

  def venue_details(venue)
    user_signed_in? ? venue.details_for(current_user) : {}
  end
end
