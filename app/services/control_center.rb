require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

class ControlCenter

  include Services::Subscriber
  include Services::Publisher
  include Services::FogEc2

  subscribe queue: 'streamer_fsm', handler: :streamer_ready

  def streamer_ready(info, prop, body)

  end

end
