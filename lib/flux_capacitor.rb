#!/usr/bin/env ruby

require 'daemons'

# The FluxCapacitor is a headless Rails process which subscribes and
# publishes to Faye. Nothing more, nothing less. All other names were
# already taken.
#
class FluxCapacitor

  PATTERN = %r{^/live/up/t(\d+)/u(\d+)$}

  NO_CHANNEL = "no channel info for message %s"

  attr_accessor :client, :listeners

  def run
    extension = Faye::Authentication::ClientExtension.new(Settings.faye.secret_token)
    self.listeners = Hash.new { |h, k| h[k] = {} }
    EM.run {
      self.client = Faye::Client.new(Settings.faye.server)
      client.add_extension(extension)

      channel = '/live/up'
      puts "subscribing to #{channel}..."
      client.subscribe(channel) do |msg|
        response = process(msg)
        client.publish(*response) unless response.nil?
      end

      channel = '/register/listener'
      puts "subscribing to #{channel}..."
      client.subscribe(channel) do |msg|
        self.listeners[msg['talk']][msg['session']] ||= Time.now.to_i
        client.publish(msg['talk'], { type: 'listeners',
                                      listeners: listeners[msg['talk']].size })
      end
    }
  end

  def process(msg)
    # pp msg
    channel = msg.delete('channel')
    Rails.logger.error NO_CHANNEL % message.inspect if channel.nil?
    _, talk_id, user_id = channel.match(PATTERN).to_a
    talk = Talk.find(talk_id)

    if msg['event'] # EVENTS
      # events may only be called by the owner of a talk
      # TODO use cancan instead
      return unless user_id == talk.venue.user_id.to_s
      case msg['event']
      when 'EndTalk'
        # server annotates end_talk event with listeners
        _listeners = self.listeners.delete(talk.public_channel)
        talk.listeners = msg[:listeners] = _listeners
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
        # TODO set user state to Listening on Demote
      end
    elsif msg['state'] # STATE PROPAGATION
      talk.with_lock do
        session = talk.session || {}
        if session[user_id].nil?
          user = User.find(user_id)
          msg['user'] = session[user_id] = user.details_for(talk)
        end
        session[user_id][:state] = msg['state']
        talk.update_attribute :session, session
      end
      msg['user'] ||= { 'id' => user_id.to_i }
      print "."
    else
      Rails.logger.error "Don't know how to handle:\n#{message.to_yaml}"
    end

    [ talk.public_channel, msg ]
  rescue => e
    print 'X'
    Rails.logger.error(e.message)
    #ENV["airbrake.error_id"] = notify_airbrake(e)
    nil
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
