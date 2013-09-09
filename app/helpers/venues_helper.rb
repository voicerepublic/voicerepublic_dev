module VenuesHelper
  def recording_path(recording)
    "/system/recordings/#{recording}"
  end

  def end_in_milli(venue)
    diff = venue.end_time.utc - Time.now.utc
    diff < 0 ? 0 : diff * 1000.0
  end
end
