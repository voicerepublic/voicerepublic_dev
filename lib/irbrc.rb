def restart_streaming_server!(v)
  v = Venue.find(v) if !v.is_a?(Venue)
  v.reset!
  v.reload.become_available!
  v.reload.start_provisioning!
end

def list_venues
  Venue.not_offline.order('slug').each do |v|
    puts "%-10s %-45s %s" % [v.state, v.slug, v.stream_url]
  end
  nil
end

list_venues

puts <<EOF
Methods at your finger tips...
------------------------------------
* list_venues
* restart_streaming_server! <venue>

EOF
