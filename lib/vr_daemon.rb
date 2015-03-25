#!/usr/bin/env ruby

require 'daemons'

class VrDaemon

  CHANNEL = '/live/up'

  attr_accessor :client

  def run
    extension = Faye::Authentication::ClientExtension.new(Settings.faye.secret_token)
    EM.run {
      self.client = Faye::Client.new(Settings.faye.server)
      client.add_extension(extension)

      puts "subcribing to #{CHANNEL}..."
      client.subscribe(CHANNEL) do |msg|
        process(msg)
      end
    }
  end

  def process(msg)
    case msg['event']
    when 'EndTalk'
      _, talk_id, user_id = msg['channel'].match(%r{^/live/up/t(\d+)/u(\d+)$}).to_a
      talk = Talk.find(talk_id)
      # TODO authorize
      talk.end_talk!
      client.publish talk.public_channel, event: 'EndTalk'
    else
      puts "Don't know how to handle:\n#{msg.to_yaml}"
    end
  end

end

if __FILE__ == $0
  # daemonize
  base = File.expand_path('../..', __FILE__)
  piddir = File.join(base, 'tmp', 'pids')
  Daemons.run_proc(File.basename(__FILE__), dir: piddir) do
    Dir.chdir(base)
    # pull in the whole rails environment
    puts 'booting rails...'
    require File.expand_path('config/environment', base)
    VrDaemon.new.run
  end
end
