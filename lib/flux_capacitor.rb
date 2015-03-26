#!/usr/bin/env ruby

require 'daemons'

# The FluxCapacitor is a headless Rails process which subscribes and
# publishes to Faye. Nothing more, nothing less. All other names were
# already taken.
#
class FluxCapacitor

  CHANNEL = '/live/up'
  PATTERN = %r{^/live/up/t(\d+)/u(\d+)$}

  NO_CHANNEL = "no channel info for message %s"

  attr_accessor :client, :talk

  def run
    extension = Faye::Authentication::ClientExtension.new(Settings.faye.secret_token)
    EM.run {
      self.client = Faye::Client.new(Settings.faye.server)
      client.add_extension(extension)

      puts "subscribing to #{CHANNEL}..."
      client.subscribe(CHANNEL) do |msg|
        response = process(msg)
        client.publish(talk.public_channel, response)
      end
    }
  end

  def process(message)
    message.tap do |msg|
      channel = msg.delete('channel')
      Rails.logger.error NO_CHANNEL % message.inspect if channel.nil?
      _, talk_id, user_id = channel.match(PATTERN).to_a

      if msg['event'] # EVENTS
        # events may only be called by the owner of a talk
        # TODO use cancan instead
        self.talk = Talk.joins(:venue).find(talk_id)
        return unless user_id == talk.venue.user_id.to_s
        case msg['event']
        when 'EndTalk'
          talk.end_talk!
          print 'e'
        when 'StartTalk'
          talk.start_talk!
          msg[:session] = talk.session
          msg[:talk_state] = talk.current_state
          print 's'
        else
          print 'o'
          # silently pass other events like Promote and Demote
        end
      elsif msg['state'] # STATE PROPAGATION
        user = User.find(user_id)
        self.talk = Talk.find(talk_id)
        details = user.details_for(talk)
        talk.with_lock do
          session = talk.session || {}
          session[user.id] ||= details
          session[user.id][:state] = msg['state']
          talk.update_attribute :session, session
        end
        registering = msg['state'].match(/Registering$/)
        msg['user'] = registering ? details : { id: user.id }
        print '.'
      else
        Rails.logger.error "Don't know how to handle:\n#{message.to_yaml}"
      end
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
    puts 'compressing some time while booting rails...'
    require File.expand_path('config/environment', base)
    FluxCapacitor.new.run
  end
end
