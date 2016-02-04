require 'json'
require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module Services
  module Subscriber

    extend ActiveSupport::Concern

    include Connector

    class_methods do

      def subscribe(options)
        unless defined?(subscriptions)
          class_attribute :subscriptions
          self.subscriptions = []
        end

        self.subscriptions << ->(instance, opts={}) do

          queue_name = options.delete(:queue) || options.delete(:q)
          exchange_name = options.delete(:exchange) || options.delete(:x)

          handler = options[:handler] || queue_name || exchange_name

          queue = nil

          if queue_name
            queue = instance.channel.queue(queue_name)
          elsif exchange_name
            exchange = instance.channel.fanout(exchange_name)
            queue = instance.channel.queue('', exclusive: true)
            queue.bind(exchange)
          else
            raise "Either of `exchange`, `queue`, `x` or `q` are required."
          end

          queue.subscribe(opts) do |info, prop, body|
            body = JSON.parse(body) if prop[:content_type] == 'application/json'
            # TODO fix order of params to: body, prop, info, options
            result =
              if handler.is_a?(Symbol)
                instance.send(handler, info, prop, body, options)
              else
                handler.call(body, prop, info, options)
              end
            # auto publish feature, see Services::AutoPublish
            auto_publish(result) if instance.respond_to?(:auto_publish)
          end
        end
      end
    end

    def handler(*args)
      raise 'handler not yet implemented'
    end

    def run
      last = self.class.subscriptions.last
      self.class.subscriptions.each_with_index do |s, index|
        options = (last == s) ? {block: true} : {}
        s.call(self, options)
      end
      puts 'Ready.'
    end

  end
end
