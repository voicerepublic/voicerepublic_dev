require 'json'
require 'open-uri'

require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

class IcecastObserver

  include Services::Subscriber
  include Services::Publisher

  DELAY = 4

  subscribe queue: 'icecast_observer'

  def initialize
    @servers = []
    t = Thread.new do
      loop do
        observe
        sleep DELAY
      end
    end
    t.run
  end

  def handler(info, prop, body)
    @servers << JSON.parse(body)['server']
  end

  def observe
    result = @servers.map do |server|
      url = "http://#{server}/status.xml"
      xml = open(url).read
      Hash.from_xml(xml)
    end
    publish exchange: 'icecast_observer', details: result
  end

end
