require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

class Ec2Spawner

  include Services::Subscriber
  include Services::FogEc2

  subscribe queue: 'cloud_spawn'

  def handler(info, prop, body)
    server = fog.servers.create
    Thread.new do
      server.wait_for { ready? }
      publish exchange: 'spawn',
              event: 'server_ready',
              details: server.attributes
    end
  end

end
