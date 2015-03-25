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
    channel = msg.delete('channel')
    _, talk_id, user_id = channel.match(%r{^/live/up/t(\d+)/u(\d+)$}).to_a
    talk = Talk.find(talk_id)

    if msg['event']
      case msg['event']
      when 'EndTalk'
        # TODO authorize
        talk.end_talk!
      else
        puts "Don't know how to handle:\n#{msg.to_yaml}"
      end
    elsif msg['state']
      user = User.find(user_id)
      talk.with_lock do
        session = talk.session || {}
        session[user.id] ||= user.details_for(talk)
        session[user.id][:state] = msg['state']
        talk.update_attribute :session, session
      end
      msg['user'] = { id: user.id }
    else
      puts "Don't know how to handle:\n#{msg.to_yaml}"
    end

    client.publish talk.public_channel, msg
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
