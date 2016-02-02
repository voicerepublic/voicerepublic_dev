require 'bunny'

module Services
  module Connector

    attr_accessor :bunny

    def channel
      return @channel unless @channel.nil?

      self.bunny = Bunny.new read_timeout: 10, heartbeat: 10
      bunny.start
      bunny.create_channel
    end

    # def rescue_connection(*args)
    #   # TODO
    # rescue
    #   @channel = nil
    # end

  end
end
