#!/usr/bin/env ruby

require 'daemons'
require 'logger'

# The FluxCapacitor is a headless Rails process which subscribes and
# publishes to Faye. Nothing more, nothing less. All other names were
# already taken.
#
# TODO rename to HeartBeatMonitor
class FluxCapacitor

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
