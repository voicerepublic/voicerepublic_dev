#!/usr/bin/env ruby

require 'json'
require 'yaml'

require 'daemons'
require 'bunny'
require 'faraday'

# Simon the Slacker listens to an exchange ('simon' by default) on
# RabbitMQ and forwards messages to a channel on Slack. This script is
# to be run as a daemon with a path to a YAML config file as the last
# commandline argument. The config file should look like this:
#
#     slack:
#       token: <your-slack-token>
#       channel: '#simon'
#
# Setting the channel to `false` will deactivate Simon the
# Slacker. The config file may also include the following settings
# (values in this example are defaults).
#
#     slack:
#       channel: false
#       username: Simon
#       icon_emoji: ':squirrel:'
#     rabbitmq:
#       exchange: simon
#
class SimonTheSlacker

  def initialize(config_file)
    @config_file = config_file
    reconnect
  end

  def run
    puts 'Simon started slacking.'
    x_name = (config['rabbitmq'] && config['rabbitmq']['exchange']) || 'simon'
    exchange = @channel.fanout(x_name)
    queue = @channel.queue('', exclusive: true)
    queue.bind(exchange)

    queue.subscribe(block: true) do |info, prop, body|
      msg = JSON.parse(body)
      slack msg['msg']
    end
  rescue Bunny::ConnectionClosedError => e
    # if the connection is closed make it reconnect and try again
    reconnect
    retry
  end

  private

  def reconnect
    @bunny = Bunny.new read_timeout: 10, heartbeat: 10
    @bunny.start
    @channel = @bunny.create_channel
  end

  def slack(message, opts={})
    unless config['slack']['channel']
      puts message
      return
    end
    defaults = {
      channel:    config['slack']['channel'],
      username:   config['slack']['username'] || 'Simon',
      text:       message,
      icon_emoji: config['slack']['icon_emoji'] || ':squirrel:'
    }
    payload = defaults.merge(opts)
    faraday.post slack_url, payload: JSON.unparse(payload)
  end

  def faraday
    @faraday ||= Faraday.new(url: slack_url) do |f|
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end
  end

  def config
    @config ||= YAML.load(File.read(@config_file))
  end

  def slack_url
    @slack_url ||=
      "https://voicerepublic.slack.com" +
      "/services/hooks/incoming-webhook" +
      "?token=" + config['slack']['token']
  end

end

if __FILE__ == $0
  # daemonize
  base = File.expand_path('../..', __FILE__)
  piddir = File.join(base, 'tmp', 'pids')
  sts = nil
  Daemons.run_proc(File.basename(__FILE__), dir: piddir) do
    Dir.chdir(base)
    config = File.expand_path(ARGV.last || 'simon_the_slacker.yml', base)
    sts = SimonTheSlacker.new(config)
    puts 'Simon is ready to slack.'
    sts.run
  end
end
