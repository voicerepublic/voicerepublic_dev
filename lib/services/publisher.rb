require 'json'

module Services
  module Publisher

    include Connector
    include LocalConfig

    def publish(options)
      return unless config.bunny.enabled

      queue_name = options.delete(:queue) || options.delete(:q)
      exchange_name = options.delete(:exchange) || options.delete(:x)

      json = JSON.unparse(options)

      if queue_name
        queue = channel.queue(queue_name)
        channel.default_exchange.publish(json,
                                         routing_key: queue.name,
                                         content_type: 'application/json')
      elsif exchange_name
        channel.fanout(exchange_name).publish(json,
                                              content_type: 'application/json')
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
