require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

# TODO use a routing key like `cloud.ec2.reap`
class Ec2Reaper

  include Services::Subscriber
  include Services::FogEc2

  subscribe q: 'reap_server'

  def reap_server(*args)
    body = args.shift
    id = body['id']
    fog.server_by_id(id).destroy
  end

end

# SERVICE Ec2Reaper
# reap_server ->
# => FogEc2
