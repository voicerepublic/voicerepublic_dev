#!/usr/bin/env ruby

require 'json'
require 'yaml'

require 'daemons'
require 'bunny'
require 'faraday'

class Auditor

  def initialize(config_file)
    @config_file = config_file
    reconnect
  end

  def run
    puts 'Auditor started auditing.'
    x_name = 'audit'
    exchange = @channel.fanout(x_name)
    queue = @channel.queue('', exclusive: true)
    queue.bind(exchange)

    queue.subscribe(block: true) do |info, prop, body|
      slack body
    end
  rescue Bunny::ConnectionClosedError
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
      channel:    config['slack']['channel'] || '#audit',
      username:   'Auditor',
      text:       message,
      icon_emoji: ':neckbeard:'
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
    config = File.expand_path(ARGV.last || 'auditor.yml', base)
    sts = Auditor.new(config)
    puts 'Auditor is ready to slack.'
    sts.run
  end
end
