#!/usr/bin/env ruby

# This is just a proof of concept and shows how to subscribe to
# metrics on RabbitMQ.
#
# Run with
#
#   ruby lib/metrics_listener.rb run

require 'daemons'
require 'bunny'
require 'json'

# require 'yaml'

class MetricsListener

  attr_accessor :bunny, :channel

  def initialize
    self.bunny = Bunny.new read_timeout: 10, heartbeat: 10
    bunny.start
    self.channel = bunny.create_channel
  end

  def run
    exchange = channel.fanout('metrics')
    queue = channel.queue('', exclusive: true)
    queue.bind(exchange)

    puts 'Listening for metrics...'
    queue.subscribe(block: true) do |info, prop, body|
      msg = JSON.parse(body)
      puts "%8.2f % -35s %s" % [msg['duration'], msg['name'], msg['visual']]
      # puts msg.to_yaml
    end
  end

end

if __FILE__ == $0
  # daemonize
  base = File.expand_path('../..', __FILE__)
  piddir = File.join(base, 'tmp', 'pids')
  Daemons.run_proc(File.basename(__FILE__), dir: piddir) do
    Dir.chdir(base)
    MetricsListener.new.run
  end
end
