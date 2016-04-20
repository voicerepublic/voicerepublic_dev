#!/usr/bin/env ruby

require 'daemons'
require 'logger'

# The FluxCapacitor is a headless Rails process which subscribes and
# publishes to Faye. Nothing more, nothing less. All other names were
# already taken.
#
class FluxCapacitor

  PATTERN = %r{^/live/up/t(\d+)/u(\d+)$}

  NO_CHANNEL = "no channel info for message %s"

  attr_accessor :client, :heartbeats

  def run
    logger.info 'FluxCapacitor started.'
    start_heart_monitor

    extension = Faye::Authentication::ClientExtension.new(Settings.faye.secret_token)
    EM.run {

      logger.info 'EM run.'
      self.client = Faye::Client.new(Settings.faye.server)
      client.add_extension(extension)
      logger.info 'Faye::Client established.'

      begin
        logger.info "Subscribing to /live/up..."
        client.subscribe('/live/up') do |msg|
          logger.info "/live/up #{msg.inspect}"
          response = process(msg)
          client.publish(*response) unless response.nil?
        end

        logger.info "Subscribing to /register/listener..."
        client.subscribe('/register/listener') do |msg|
          logger.info "/register/listener #{msg.inspect}"
          talk_id = msg['talk_id']
          # TODO: We can skip persisting and publishing this information
          # when the listener is already known
          talk = Talk.find_by(id: talk_id)
          if talk.try(:live?)
            talk.add_listener! msg['session']
            client.publish(talk.public_channel, { type: 'listeners',
                                                  listeners: talk.listeners.size })
            print 'l'
          end
        end

        logger.info "Subscribing to /heartbeat..."
        client.subscribe('/heartbeat') do |msg|
          identifier = msg['identifier']
          if heartbeats[identifier].nil?
            logger.debug("#{identifier} appeared")
            Device.find_by(identifier: identifier).appear!
          end
          logger.debug("#{identifier} heartbeat")
          heartbeats[identifier] = {
            interval: msg['interval'],
            last: Time.now
          }
        end

      rescue => e
        logger.fatal 'E1 '+error(e)
      end

    }
    logger.info 'FluxCapacitor terminated. (This should never happen!)'
  rescue => e
    logger.fatal 'E0 '+error(e)
  end

  def start_heart_monitor
    self.heartbeats = {}
    grace_factor = 2
    Thread.new do
      loop do
        sleep 1
        heartbeats.each do |identifier, values|
          if values[:last] + values[:interval] * grace_factor < Time.now
            logger.debug("#{identifier} disappeared")
            Device.find_by(identifier: identifier).disappear!
            heartbeats.delete(identifier)
          end
        end
      end
    end
  end

  def process(msg)
    # pp msg
    channel = msg.delete('channel')
    if channel.nil?
      Rails.logger.error NO_CHANNEL % msg.inspect
      logger.warn NO_CHANNEL % msg.inspect
    end

    _, talk_id, user_id = channel.match(PATTERN).to_a
    talk = Talk.find(talk_id)

    if msg['event'] # EVENTS
      # events may only be called by the owner of a talk
      # TODO use cancan instead
      return unless user_id == talk.series.user_id.to_s
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
      Rails.logger.warn "Don't know how to handle:\n#{msg.to_yaml}"
      logger.warn "Don't know how to handle:\n#{msg.to_yaml}"
    end

    [ talk.public_channel, msg ]
  rescue => e
    print 'X'
    logger.error 'E2 '+error(e)
    # TODO propagate errors via errbit
    # ENV["airbrake.error_id"] = notify_airbrake(e)
    nil
  end

  def logger
    path = Rails.root.join('log/flux_capacitor.log')
    # FIXME Horrible Hack to make logging work on production
    path = '/home/app/app/shared/log/flux_capacitor.log' if Rails.env.production?
    @logger ||= Logger.new(path)
  end

  def error(e)
    "#{e.class.name}: #{e.message}\n" + e.backtrace * "\n"
  end

end

if __FILE__ == $0
  # daemonize
  base = File.expand_path('../..', __FILE__)
  piddir = File.join(base, 'tmp', 'pids')
  fc = nil
  Daemons.run_proc(File.basename(__FILE__), dir: piddir) do
    Dir.chdir(base)
    # pull in the whole rails environment
    puts 'Compressing some time while booting rails...'
    require File.expand_path('config/environment', base)
    fc = FluxCapacitor.new
    puts 'Ready.'
    fc.run
  end
  fc.logger.fatal "FluxCapacitor daemon exiting."
end
