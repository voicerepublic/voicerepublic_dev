require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

# TODO require rails env

# The ControlCenter ties all other services together.
class ControlCenter

  include Services::Subscriber
  include Services::Publisher

  subscribe queue: 'streamer_fsm', handler: :streamer_transition

  def streamer_transition(info, prop, body)
    # if state now 'ready'
    # if talk.starts_at - now <= 30 min
    # details = { tpye: t2.micro, password: password, ami: ami }
    # publish q: 'spawn_server', details: details
  end

end
