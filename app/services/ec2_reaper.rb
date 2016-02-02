require 'json'

require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

class Ec2Reaper

  include Services::Subscriber
  include Services::FogEc2

  subscribe queue: 'cloud_reap'

  def handler(info, prop, body)
    id = JSON.parse(body)[:id]
    fog.server_by_id(id).destroy
  end

end
