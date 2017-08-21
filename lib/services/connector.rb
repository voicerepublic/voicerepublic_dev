require 'bunny'

# TODO rename to BunnyConnector
module Services
  module Connector

    attr_accessor :bunny

    def channel
      @channel ||= reconnect
    end

    def reconnect
      self.bunny = Bunny.new hostname: "vr-rabbitmq", read_timeout: 11, heartbeat: 30
      bunny.start
      bunny.create_channel
    end

  end
end
