require 'open-uri'
require 'ostruct'
require 'active_support/core_ext'

class RtmpWatcher

  class << self
    def run
      new.run
    end
  end

  def run
    url = 'http://localhost:8080/stat'
    xml = open(url).read
    hash = Hash.from_xml(xml)
    data = deep_ostruct(hash)
    
    data.rtmp.server.application.each do |app|
      if app.live.nclients.to_i > 0
        app.live.stream.each do |stream|
          puts [stream.name, stream.nclients, stream.bw_in, app.name] * ' '
        end
      end
    end
    
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
  
end

RtmpWatcher.run if __FILE__ == $0
