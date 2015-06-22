class BunnyWrapper

  attr_accessor :connection, :channel

  def initialize
    reconnect
  end

  # def subscribe(exchange_name, options={})
  #   exchange = CHANNEL.fanout(exchange_name)
  #   queue = CHANNEL.queue("", exclusive: true)
  #   queue.bind exchange
  #   queue.subscribe(options) do |info, prop, body|
  #     data = OpenStruct.new(JSON.parse(body))
  #     yield data, info, prop
  #   end
  # end

  def publish(data)
    if queue = data.delete(:queue) || data.delete(:q)
      json = JSON.unparse(data)
      queue = channel.queue(queue)
      channel.default_exchange.publish(json, routing_key: queue.name)
    elsif exchange = data.delete(:exchange) || data.delete(:x)
      channel.fanout(exchange).publish(JSON.unparse(data))
    else
      raise "Either of `exchange`, `queue`, `x` or `q` are required."
    end
  rescue Bunny::ConnectionClosedError
    # if the connection is closed make it reconnect and try again
    reconnect
    publish(data)
  end

  private

  def reconnect
    self.connection = Bunny.new read_timeout: 10, heartbeat: 10
    self.connection.start
    self.channel = connection.create_channel
  end

end

BUNNY = BunnyWrapper.new

# example publish
BUNNY.publish(queue: 'log', pid: $$, state: 'Rails ready')


# And now for something completely different...
unless Rails.env.test?

  # Subscribe to all of Rails' notifications and publish to an
  # exchange on RabbitMQ. Publishing to an exchange means, that if
  # nobody is listending RabbitMQ will discard these messages
  # instantly. Much like it would be the case if we'd use Faye for it.
  ActiveSupport::Notifications.subscribe(//) do |*args|
    data = args.last

    # visual should be a one line representation of the event
    visual =
      case args.first # name

      # generic notifications
      when 'sql.active_record'
        "[%s] %s" % [ data[:name],
                      data[:sql].split("\n").map(&:strip) * ' ' ]

      when 'instantiation.active_record'
        "%s * %s" % [ data[:record_count],
                      data[:class_name] ]

      when 'load_config_initializer.railties'
        data[:initializer].sub(Rails.root.to_s, '')

      when '!render_template.action_view',
           '!compile_template.action_view'
        data[:virtual_path]

      when 'render_template.action_view'
        data[:layout]

      when 'render_partial.action_view'
        data[:identifier].sub(Rails.root.to_s, '')

      when 'render_collection.action_view'
        "%s %s" % [ data[:identifier].sub(Rails.root.to_s, ''),
                    data[:count] ]

      when 'process_action.action_controller',
           'start_processing.action_controller'
        "%s %s %s %s %s#%s" % [ data[:method],
                                data[:path],
                                data[:format],
                                data[:status],
                                data[:controller],
                                data[:action] ]

      # custom notifications
      when 'flyer.inkscape.vr'
        data[:cmd]

      when 'run_chain.audio_process.vr'
        data[:chain] * ' '

      # fall back to json for unknown events
      else data.to_json
      end

    duration = (args[2] - args[1]) * 1000

    params = [
      # custom arguments
      :exchange, :duration, :visual,
      # standard arguments
      :name, :started, :finished, :unique_id, :data
    ]

    # and send it to rabbitmq
    BUNNY.publish(Hash[params.zip(args.unshift('metrics', duration, visual))])
  end

end
