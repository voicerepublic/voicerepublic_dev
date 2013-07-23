# Run with: rackup private_pub.ru -s thin -E production
require "bundler/setup"
require "yaml"
require "faye"
require "private_pub"

Faye::WebSocket.load_adapter('thin')

PrivatePub.load_config(File.expand_path("../config/private_pub.yml", __FILE__), ENV["RAILS_ENV"] || "development")

faye = PrivatePub.faye_app


class Persistor

  attr_accessor :history, :subscriptions

  def added(e)
    self.history = Hash.new { |h, k| h[k] = [] }
    self.subscriptions = Hash.new { |h, k| h[k] = [] }
  end

  def incoming(message, callback)
    channel = message['channel']
    if channel == '/meta/subscribe' 
      subscription = message['subscription']
      client_id = message['clientId']
      if subscription =~ /\/chatchannel\/(.*)/
        subscriptions[client_id] << $1
        puts "SUBSCRIBE #{client_id} TO #{$1}"
      end
    elsif channel =~ /\/chatchannel\/(.*)/
      history[$1] << message['data']
      puts "ARCHIVED #{history[$1].size} MESSAGES FOR #{$1}"
    end      

    callback.call(message)
  end

  def outgoing(message, callback)
    channel = message['channel']
    if channel =~ /\/meta\/subscribe/
      subscription = message['subscription']
      if subscription =~ /\/chatchannel\/(.*)/
        client_id = message['clientId']
        if subscriptions[client_id].delete($1)
          unless history[$1].empty?
            message['data'] = { 'eval' => history[$1].join('') }
            puts "ADDED #{history[$1].size} ARCHIVED MESSAGES FOR #{$1} TO SUBSCRIBE RESPONSE"
            puts message.to_yaml
          end
        end
      end
    end

    callback.call(message)
  end

end

faye.add_extension(Persistor.new)


run faye
