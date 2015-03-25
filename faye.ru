# Namespaces in use
#
# * /dj
# * /monitoring
# * /event/talk
# * /notification
# * /stat/t1051-u1
# * /stat
# * /t1051/public      (TODO rename to /live/down/t1051/public)
# * /t1051/u1          (TODO rename to /live/down/t1051/u1)
# * /live/up/t1051/u1  (will be squashed by ChannelSquasher)
#     => /live/up { channel: '/live/up/t1051/u1' }
#
# Run this file with
#
#    rackup faye.ru -E production
#
require 'yaml'
require 'faye'
require 'faye/authentication'
require File.expand_path('../lib/faye_ttl', __FILE__)
require File.expand_path('../lib/faye_squasher', __FILE__)


# INSTANCIATE

Faye::WebSocket.load_adapter('thin')
faye = Faye::RackAdapter.new(mount: '/faye', timeout: 15)


# AUTHENTICATION

# TODO figure out how to use Settings here
file = File.expand_path('../config/settings.yml', __FILE__)
config = YAML.load(File.read(file))
secret = config['faye']['secret_token']

faye.add_extension Faye::Authentication::ServerExtension.new(secret)


# CUSTOM EXTENSIONS

rules = { '/live/up' => %r{^/live/up/t\d+/u\d+$} }
faye.add_extension FayeSquasher.new(rules)

faye.add_extension FayeTtl.new(channels: %w( /dj
                                             /event/talk
                                             /monitoring
                                             /notification
                                             /stat ))

# OUTPUT

env = ENV['RAILS_ENV'] || 'development'
if env == 'development'
  puts "We're in dev mode, showing logs..."
  faye.on(:publish) do |client_id, channel, data|
    puts "publish #{client_id} #{channel} #{data.inspect}"
  end

  faye.on(:subscribe) do |client_id, channel|
    puts "subscribe #{client_id} #{channel}"
  end
end


# RUN

run faye
