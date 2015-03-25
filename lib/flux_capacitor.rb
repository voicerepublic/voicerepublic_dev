#!/usr/bin/env ruby

require 'daemons'

# The FluxCapacitor is a headless Rails process which subscribes to
# Faye. Nothing more, nothing less. All other names were already
# taken.
#
class FluxCapacitor

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

    if msg['event'] # EVENTS
      # events may only be called by the owner of a talk
      # TODO use cancan instead
      return unless user_id == talk.user_id
      case msg['event']
      when 'EndTalk'
        talk.end_talk!
      when 'StartTalk'
        talk.start_talk!
        msg[:session] = talk.session
        msg[:talk_state] = talk.current_state
      else
        # silently pass other events like Promote and Demote
      end
    elsif msg['state'] # STATE PROPAGATION
      user = User.find(user_id)
      details = user.details_for(talk)
      talk.with_lock do
        session = talk.session || {}
        session[user.id] ||= details
        session[user.id][:state] = msg['state']
        talk.update_attribute :session, session
      end
      registering = msg['state'].match(/Registering$/)
      msg['user'] = registering ? details : { id: user.id }
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
    FluxCapacitor.new.run
  end
end
