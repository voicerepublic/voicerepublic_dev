require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

# TODO use a routing key like `cloud.ec2.reap`
class Ec2Reaper

  include Services::Subscriber
  include Services::FogEc2

  subscribe q: 'reap_server'

  def reap_server(info, prop, body, opts)
    id = body['id']
    fog.server_by_id(id).destroy
  end

end
