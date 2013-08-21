# Run with: rackup private_pub.ru -s thin -E production
require "bundler/setup"
require "yaml"
require "faye"
require "private_pub"

Faye::WebSocket.load_adapter('thin')

PrivatePub.load_config(File.expand_path("../config/private_pub.yml", __FILE__), ENV["RAILS_ENV"] || "development")

faye = PrivatePub.faye_app


class FayeNSA

  HISTORIZE_REGEX = /\/(chatchannel|story)\/(.*)/

  attr_accessor :history

  def added(e)
    self.history = Hash.new { |h, k| h[k] = [] }
  end

  def incoming(message, callback)
    channel = message['channel']
    if channel =~ HISTORIZE_REGEX
      history[$2] << message['data']['eval']
    end

    callback.call(message)
  end

  def outgoing(message, callback)
    channel = message['channel']
    if channel =~ /\/meta\/subscribe/
      subscription = message['subscription']
      if subscription =~ HISTORIZE_REGEX
        unless history[$2].empty?
          message['ext'] = { 'data' => { 'eval' => history[$2].join('') } }
        end
      end
    end
    
    callback.call(message)
  end

end

faye.add_extension(FayeNSA.new)

# require 'logger'
# logfilename = File.expand_path('../log/private_pub-publish.log', __FILE__)
# logfile = File.new(logfilename, 'a')
# logfile.sync = true
# logger = Logger.new(logfile)
# faye.bind(:publish) do |client_id, channel, data|
#   logger.info "publish #{client_id} #{channel} #{data.inspect}"
# end
# faye.bind(:subscribe) do |client_id, channel|
#   logger.info "subscribe #{client_id} #{channel}"
# end

run faye
