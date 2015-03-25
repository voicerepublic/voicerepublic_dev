# Run with
#
#    rackup faye.ru -E production
#
require 'yaml'
require 'faye'
require 'faye/authentication'
require File.expand_path('../lib/faye_ttl', __FILE__)


# INSTANCIATE

Faye::WebSocket.load_adapter('thin')
faye = Faye::RackAdapter.new(mount: '/faye', timeout: 15)


# AUTHENTICATION

# TODO figure out how to use Settings here
file = File.expand_path('../config/settings.yml', __FILE__)
config = YAML.load(File.read(file))
secret = config['faye']['secret_token']

faye.add_extension Faye::Authentication::ServerExtension.new(secret)


# PERSISTENCE

faye.add_extension FayeTtl.new(channels: %w( /dj
                                             /event/talk
                                             /monitoring
                                             /notification
                                             /stat ))


# OUTPUT

env = ENV['RAILS_ENV'] || 'development'
if env == 'development'
  puts "We're in dev mode, showing logs..."
  faye.bind(:publish) do |client_id, channel, data|
    puts "publish #{client_id} #{channel} #{data.inspect}"
  end

  faye.bind(:subscribe) do |client_id, channel|
    puts "subscribe #{client_id} #{channel}"
  end
end


# RUN

run faye
