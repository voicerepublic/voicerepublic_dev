class FakeDisconnect < MonitoredJob

  def perform
    venue = Venue.find(opts[:id])
    venue.disconnect!
  end

end
