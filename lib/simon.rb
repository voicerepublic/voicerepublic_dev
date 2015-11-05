class Simon

  # To extend Simon's Brain create a new method based on the name of a
  # class (underscored). Make it take as many arguments as you want to
  # pass when invoking `comprehend` And make it return the message to
  # be send as String.
  #
  # Checkout commit 7af5dc8 to see how easy it is!
  #
  module Brain

    extend self

    def user(user, action)
      case action
      when :registered
        "#{user.name} just registered with #{user.email}."
      end
    end

    def manual_transaction(obj)
      quantity = obj.details[:quantity].to_i
      payment = obj.details[:payment].to_i
      admin = AdminUser.find(obj.source_id).email
      name = User.find(obj.details[:user_id]).name
      msg = nil

      # deduct credits
      if quantity < 0 && payment == 0
        msg = "Admin #{admin} deducted #{quantity} credits from #{name}."
      end
      # undo booking
      if quantity < 0 && payment < 0
        msg = "Admin #{admin} undid a booking for #{name}, " +
              "by deducting #{quantity} credits and giving EUR #{payment} back."
      end
      # donate
      if quantity > 0 && payment == 0
        msg = "Admin #{admin} donated #{quantity} credits to #{name}."
      end
      # sale
      if quantity > 0 && payment > 0
        msg = "Admin #{admin} sold #{quantity} credits for EUR #{payment} to #{name}."
      end
      # track previous sale
      if quantity == 0 && payment > 0
        msg = "Admin #{admin} tracked a sale for EUR #{payment} " +
              "to #{name}, retrospectively."
      end

      # noop
      if quantity == 0 && payment == 0
        msg = "Admin #{admin} contemplated about the meaning of life."
      end
      # weird stuff going on
      if (quantity < 0 && payment > 0) ||
         (quantity >= 0 && payment < 0)
        msg = "Admin #{admin} and #{name} seem to be in cahoots. " +
              "Alert the authorities, fishy transaction going on."
      end

      raise 'Unknown case in manual transaction!' unless msg
      msg
    end

  end

  include Singleton

  # poor man's delegate
  class << self
    def says(*args)
      return unless Settings.simon.enabled
      instance.publish(*args)
    end

    def comprehend(*args)
      return unless Settings.simon.enabled
      instance.comprehend(*args)
    end
  end

  # lookup if simon's brain knows how to comprehend the arguments
  # based on the first argument's class
  def comprehend(*args)
    method = args.first.class.name.underscore.to_sym
    msg = "Sorry, I don't know how to comprehend '#{method}'."
    msg = Brain.send(method, *args) if Brain.respond_to?(method)
    publish x: 'simon', msg: msg
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
      queue = @channel.queue(queue)
      @channel.default_exchange.publish(json, routing_key: queue.name)
    elsif exchange = data.delete(:exchange) || data.delete(:x)
      @channel.fanout(exchange).publish(JSON.unparse(data))
    else
      raise "Either of `exchange`, `queue`, `x` or `q` are required."
    end
  rescue Bunny::ConnectionClosedError => e
    # if the connection is closed make it reconnect and try again
    reconnect
    retry
  end

  private

  def initialize
    reconnect
  end

  def reconnect
    @connection = Bunny.new read_timeout: 10, heartbeat: 10
    @connection.start
    @channel = @connection.create_channel
  end

end

# example publish, which should probably go because of
# http://rubybunny.info/articles/connecting.html#using_bunny_with_unicorn

# Simon.says(queue: 'log', pid: $$, state: 'Rails ready')
