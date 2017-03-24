def venues
  Venue.not_offline.order('state').each do |v|
    puts "%20s %40s" % [v.state, v.name]
  end
end

def restart_streaming_server!(v)
  v = Venue.find(v) if !v.is_a?(Venue)
  v.reset!
  v.reload.become_available!
  v.reload.start_provisioning!
end
