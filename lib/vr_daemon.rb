#!/usr/bin/env ruby

# pull in the whole rails environment
require File.expand_path('../../config/environment', __FILE__)
require 'daemons'

class VrDaemon

  CHANNEL = '/live/up'

  def run
    extension = Faye::Authentication::ClientExtension.new(Settings.faye.secret_token)
    EM.run {
      client = Faye::Client.new(Settings.faye.server)
      client.add_extension(extension)

      puts "subcribing to #{CHANNEL}..."
      client.subscribe(CHANNEL) do |msg|
        process(msg)
      end
    }
  end

  def process(msg)
    p msg
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
