require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

puts 'booting rails...'
require File.expand_path(File.join(%w(.. .. .. config environment)), __FILE__)

# The ControlCenter ties all other services together.
#
class ControlCenter

  include Services::Subscriber
  include Services::Publisher

  subscribe q: 'streamer_transition'
  subscribe x: 'sites_observed'
  subscribe x: 'server_ready'
  subscribe x: 'talk_transition'
  subscribe x: 'transaction_transition'

  def streamer_transition(*args)
    # body, prop, info, opts = *args
    # if state now 'ready'
    # if talk.starts_at - now <= 30 min
    # details = { tpye: t2.micro, password: password, ami: ami }
    # publish q: 'spawn_server', details: details
  end

  def sites_observed(*args)
    # body, prop, info, opts = *args
    # TODO do some number chrunching and pass message on to clients, use routing key
  end

  def server_ready(*args)
    # body, prop, info, opts = *args
    # TODO a icecast server is ready, pass message on to clients, use routing key
    # publish x: 'set_streaming_server'
    # TODO publish url to icecast_observer to receive status via icecast_status
    # publish q: 'new_icecast_server', url: 'http://admin:hackem@136.243.209.123:8000/admin/stats.xml'
  end

  def talk_transition(*args)
    # body, prop, info, opts = *args
    # if talk ended
    # talk = Talk.find(id)
    # publish q: 'reap_server', id: talk.streaming_server_id
  end

end

# SERVICE ControlCenter
# streamer_transition ->
# sites_observed ->
# server_ready ->
# talk_transition ->
# transaction_transition ->
# -> spawn_server
# -> new_icecast_server
# -> reap_server
