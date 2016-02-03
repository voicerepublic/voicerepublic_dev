# Using AutoPublish the return value of subscribe handlers is
# automatically published to RabbitMQ, which allows for easier testing.
#
# If the return value is a hash it will directly be passed to
# `publish`, if it is an aray it will be treated as a list of
# messages, each published one by one.
#
module Services
  module AutoPublish

    include Publisher

    def auto_publish(messages)
      messages = [messages] unless messages.is_a?(Array)

      messages.each { |message| publish(message) }
    end

  end
end
