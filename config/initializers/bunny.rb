class BunnyWrapper

  attr_accessor :connection, :channel

  def initialize
    self.connection = Bunny.new read_timeout: 10, heartbeat: 10
    self.connection.start
    self.channel = connection.create_channel
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
  end

end

BUNNY = BunnyWrapper.new

# example publish
BUNNY.publish(queue: 'log', pid: $$, state: 'Rails ready')
