require 'open-uri'

require 'yaml' # active_support needs it
require 'active_support'
require 'active_support/core_ext'

require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

class IcecastObserver

  include Services::Subscriber
  include Services::Publisher

  DELAY = 4 # 4 seconds

  subscribe q: 'icecast_observer'

  attr_accessor :servers

  def initialize
    self.servers = []
  end

  def run
    @thread = Thread.new do
      loop do
        observe
        sleep DELAY
      end
    end
    @thread.run

    super # Services::Subscriber#run
  end

  def icecast_observer(info, prop, body)
    self.servers << body['url']
  end

  def observe
    result = servers.map do |url|
      xml = open(url).read
      # TODO remove server from list if connection fails x times
      Hash.from_xml(xml)
    end
    publish x: 'icecast_status', details: result
  end

end
