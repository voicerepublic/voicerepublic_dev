#!/usr/bin/env ruby

require File.expand_path('../../config/environment', __FILE__)
require 'daemons'

class VrDaemon

  DELAY = 4

  def run
    extension = Faye::Authentication::ClientExtension.new(Settings.faye.secret_token)
    EM.run {
      client = Faye::Client.new(Settings.faye.server)
      client.add_extension(extension)

      client.subscribe('/stat') do |message|
        puts message.inspect
      end

      #loop do
      #  Faye.publish_to '/heartbeat', { hello: true }
      #  sleep DELAY
      #end
    }
  end

end

if __FILE__ == $0
  # daemonize
  base = File.expand_path('../..', __FILE__)
  piddir = File.join(base, 'tmp', 'pids')
  Daemons.run_proc(File.basename(__FILE__), dir: piddir) do
    VrDaemon.new.run
  end
end
