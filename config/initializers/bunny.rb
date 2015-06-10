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

  def publish_to_queue(queue_name, data)
    queue = channel.queue(queue_name)
    channel.default_exchange.publish(JSON.unparse(data), routing_key: queue.name)
  end

end

BUNNY = BunnyWrapper.new

# example publish
BUNNY.publish_to_queue('log', pid: $$, state: 'Rails ready')
