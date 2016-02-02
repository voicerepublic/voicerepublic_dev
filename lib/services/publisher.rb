require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module Services
  module Publisher

    extend ActiveSupport::Concern

    include Connector

    def publish(data)
      exchange = options.delete(:exchange)
      if queue = data.delete(:queue) || data.delete(:q)
        json = JSON.unparse(data)
        queue = @channel.queue(queue)
        @channel.default_exchange.publish(json, routing_key: queue.name)
      elsif exchange = data.delete(:exchange) || data.delete(:x)
        @channel.fanout(exchange).publish(JSON.unparse(data))
      else
        raise "Either of `exchange`, `queue`, `x` or `q` are required."
      end
    rescue Bunny::ConnectionClosedError
      # if the connection is closed make it reconnect and try again
      reconnect
      retry
    end

  end
end
