class ShutdownVenue < MonitoredJob

  def perform
    venue = Venue.find(opts[:id])
    venue.reset!
  end

end
