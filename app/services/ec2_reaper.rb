require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

class Ec2Reaper

  include Services::Subscriber
  include Services::FogEc2

  subscribe queue: 'reap_server'

  def reap_server(info, prop, body)
    id = body['id']
    fog.server_by_id(id).destroy
  end

end
