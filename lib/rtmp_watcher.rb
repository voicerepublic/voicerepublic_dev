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
        app.live.stream.each do |stream|
          publish "/stat/#{stream.name}",
                  payload[stream.name] = {
                    nclients: stream.nclients,
                    bw_in: stream.bw_in,
                    app_name: app.name,
                    codec: stream.meta.audio.codec
                  }
        end
      end
    end
    publish "/stat", payload
  end
  
  private

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
  # configure private pub
  path = File.expand_path("../../config/private_pub.yml", __FILE__)
  PrivatePub.load_config(path, ENV['RAILS_ENV'] || 'development')

  # daemonize
  Daemons.run_proc(File.basename(__FILE__)) do
    RtmpWatcher.new.run
  end
end
