require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

puts 'booting rails...'
require File.expand_path(File.join(%w(.. .. .. config environment)), __FILE__)

# The ControlCenter ties all other services together.
class ControlCenter

  include Services::Subscriber
  include Services::Publisher

  subscribe q: 'streamer_transition'
  subscribe x: 'sites_observed'
  subscribe x: 'server_ready'
  subscribe x: 'talk_transition'
  subscribe x: 'transaction_transition'

  def streamer_transition(info, prop, body, opts)
    # if state now 'ready'
    # if talk.starts_at - now <= 30 min
    # details = { tpye: t2.micro, password: password, ami: ami }
    # publish q: 'spawn_server', details: details
  end

  def sites_observed(info, prop, body, opts)
    # TODO do some number chrunching and pass message on to clients, use routing key
  end

  def server_ready(info, prop, body, opts)
    # TODO a icecast server is ready, pass message on to clients, use routing key
    # publish x: 'set_streaming_server'
    # TODO publish url to icecast_observer to receive status via icecast_status
    # publish q: 'new_icecast_server', url: 'http://admin:hackem@136.243.209.123:8000/admin/stats.xml'
  end

  def talk_transition(info, prop, body, opts)
    # if talk ended
    # talk = Talk.find(id)
    # publish q: 'reap_server', id: talk.streaming_server_id
  end

  def transaction_transition(info, prop, body, opts)
    # if event == 'processing/closed/close' and remaining < 3 and user.paying?
    # publish q: 'techne', action: 'create_task', payload: {}
  end

end
