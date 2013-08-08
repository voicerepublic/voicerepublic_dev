# Run with: rackup private_pub.ru -s thin -E production
require "bundler/setup"
require "yaml"
require "faye"
require "private_pub"

Faye::WebSocket.load_adapter('thin')

PrivatePub.load_config(File.expand_path("../config/private_pub.yml", __FILE__), ENV["RAILS_ENV"] || "development")

faye = PrivatePub.faye_app


class FayeNSA

  attr_accessor :history

  def added(e)
    self.history = Hash.new { |h, k| h[k] = [] }
  end

  def incoming(message, callback)
    channel = message['channel']
    if channel =~ /\/chatchannel\/(.*)/
      history[$1] << message['data']['eval']
    end

    callback.call(message)
  end

  def outgoing(message, callback)
    channel = message['channel']
    if channel =~ /\/meta\/subscribe/
      subscription = message['subscription']
      if subscription =~ /\/chatchannel\/(.*)/
        unless history[$1].empty?
          message['ext'] = { 'data' => { 'eval' => history[$1].join('') } }
        end
      end
    end
    
    callback.call(message)
  end

end

# faye.add_extension(FayeNSA.new)


run faye
