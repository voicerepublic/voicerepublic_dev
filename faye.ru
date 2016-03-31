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
# * /live/up/t1051/u1  (will be squashed by FayeSquasher)
#     => /live/up { channel: '/live/up/t1051/u1' }
#
# Run this file with
#
#    rackup faye.ru -E production
#
require 'yaml'
require 'faye'
require 'faye/authentication'
require File.expand_path('../lib/faye_squasher', __FILE__)
require File.expand_path('../lib/faye_eigenfan', __FILE__)


# INSTANCIATE

Faye::WebSocket.load_adapter('thin')
faye = Faye::RackAdapter.new(mount: '/faye', timeout: 15)


# AUTHENTICATION

# TODO figure out how to use Settings here
file = File.expand_path('../config/settings.local.yml', __FILE__)
config = YAML.load(File.read(file))
secret = config['faye']['secret_token']

faye.add_extension Faye::Authentication::ServerExtension.new(secret)


# CUSTOM EXTENSIONS

rules = {
  # oldschool
  '/live/up' => %r{^/live/up/t\d+/u\d+$},
  # newschool
  '/up/venues' => %r{^/up/user/\d+/venue/\d+$}
}
faye.add_extension FayeSquasher.new(rules)

channels = %w(/down/venues)
faye.add_extension FayeEigenfan.new(channels)



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
