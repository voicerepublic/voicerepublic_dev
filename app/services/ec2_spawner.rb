require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

class Ec2Spawner

  include Services::Subscriber
  include Services::FogEc2

  subscribe q: 'spawn_server'

  def spawn_server(*args)
    server = fog.servers.create
    Thread.new do
      server.wait_for { ready? }
      publish x: 'server_ready',
              details: server.attributes
    end
  end

end

# SERVICE Ec2Spawner
# spawn_server ->
# -> server_ready
# => FogEc2
