require 'json'
require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module Services
  module Publisher

    extend ActiveSupport::Concern

    include Connector

    def publish(options)
      queue_name = options.delete(:queue) || options.delete(:q)
      exchange_name = options.delete(:exchange) || options.delete(:x)

      json = JSON.unparse(options)

      if queue_name
        queue = channel.queue(queue_name)
        channel.default_exchange.publish(json, routing_key: queue.name)
      elsif exchange_name
        channel.fanout(exchange_name).publish(json)
      else
        raise "Either of `exchange`, `queue`, `x` or `q` are required."
      end

    #rescue Bunny::ConnectionClosedError
    #  # if the connection is closed make it reconnect and try again
    #  reconnect
    #  retry
    end

  end
end
