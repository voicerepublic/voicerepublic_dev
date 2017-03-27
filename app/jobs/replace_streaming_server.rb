class ReplaceStreamingServer < MonitoredJob

  def perform
    venue = Venue.find(opts[:id])
    venue.reset!
    venue.reload.become_available!
    venue.reload.start_provisioning!
  end

end
