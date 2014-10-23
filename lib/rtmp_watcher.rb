#!/usr/bin/env ruby

require 'open-uri'
require 'ostruct'
require 'active_support/core_ext'
require 'private_pub'
require 'daemons'

class RtmpWatcher

  URL = 'http://localhost:8080/stat'
  DELAY = 4

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
      if app.live.nclients.to_i > 0
        streams = app.live.stream
        streams = [streams] unless streams.is_a?(Array)
        streams.each do |stream|
          puts '%s %s %s %s %s' % [ name     = stream.name,
                                    nclients = stream.nclients,
                                    bw_in    = stream.bw_in,
                                    app_name = app.name,
                                    codec    = stream.meta.try(:audio).try(:codec) ]
          publish "/stat/#{name}",
                  payload[name] = {
                    nclients: nclients,
                    bw_in: bw_in,
                    app_name: app_name,
                    codec: codec
                  }
        end
      end
    end
    publish "/stat", payload unless payload.empty?
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

  def publish(channel, payload)
    PrivatePub.publish_to channel, payload
  end

end


if __FILE__ == $0
  base = File.expand_path("../..", __FILE__)

  # configure private pub
  path = File.join(base, 'config', 'private_pub.yml')
  PrivatePub.load_config(path, ENV['RAILS_ENV'] || 'development')

  # daemonize
  piddir = File.join(base, 'tmp', 'pids')
  Daemons.run_proc(File.basename(__FILE__), dir: piddir) do
    RtmpWatcher.new.run
  end
end
