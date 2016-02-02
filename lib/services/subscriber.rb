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

        self.subscriptions << ->(instance) do
          handler = options[:handler] || :handler
          queue = instance.channel.queue(options[:queue])
          queue.subscribe(block: true) do |info, prop, body|
            send(handler, info, prop, body, options)
          end
        end
      end
    end

    def handler(*args)
      raise 'handler not yet implemented'
    end

    def run
      self.class.subscriptions.map { |s| s.call(self) }
    end

  end
end
