#!/usr/bin/env ruby

require 'yaml' # active_support needs it
require "active_support"

require 'open-uri'
require 'ostruct'
require 'active_support/core_ext'
require 'faye/authentication'
require 'daemons'

class RtmpWatcher

  URL = 'http://localhost:8080/stat'
  DELAY = 4

  def initialize(path)
    # TODO figure out a way to use Settings
    file = File.join(path, 'config', 'settings.local.yml')
    config = YAML.load(File.read(file))
    @server = config['faye']['server']
    @secret = config['faye']['secret_token']
  end

  def run
    loop do
      glance
      sleep DELAY
    end
  end

  def glance
    xml = open(URL).read
    hash = Hash.from_xml(xml)
    data = deep_ostruct(hash)

    payload = {}
    data.rtmp.server.application.each do |app|
      next unless app.live.nclients.to_i > 0
      next unless app.live.stream.name != ''
      streams = app.live.stream
      streams = [streams] unless streams.is_a?(Array)
      streams.each do |stream|
        puts '%s %s %s %s %s' % [ name     = stream.name,
                                  nclients = stream.nclients,
                                  bw_in    = stream.bw_in,
                                  app_name = app.name,
                                  codec    = stream.meta.try(:audio).try(:codec) ]
        publish_to "/stat/#{name}",
                   payload[name] = {
                     nclients: nclients,
                     bw_in: bw_in,
                     app_name: app_name,
                     codec: codec
                   }
      end
    end
    publish_to "/stat", payload unless payload.empty?
  end

  private

  # TODO move into trickery
  def deep_ostruct(opts)
    OpenStruct.new.tap do |o|
      opts.each do |key, value|
        o.send key + '=',
               case value
               when Hash
                 deep_ostruct(value)
               when Array
                 value.map { |v| deep_ostruct(v) }
               else value
               end
      end
    end
  end

  def publish_to(channel, payload)
    Faye::Authentication::HTTPClient.publish(@server, channel, payload, @secret)
  rescue Exception => e
    puts "He's dead, Jim."
  end

end


if __FILE__ == $0
  # daemonize
  base = File.expand_path('../..', __FILE__)
  piddir = File.join(base, 'tmp', 'pids')
  Daemons.run_proc(File.basename(__FILE__), dir: piddir) do
    RtmpWatcher.new(base).run
  end
end
