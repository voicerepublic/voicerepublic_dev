require 'faraday'
require 'json'
require 'thin'

require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

# http://localhost:15672/api/
#
# The Visualizer should only be used in development.
class Visualizer

  ENDPOINT = 'http://localhost:15672/'
  DELAY = 5
  STOPLIST = /^(|visualizer|amq\..+)$/

  WEB_HOST = '127.0.0.1'
  WEB_PORT = 9000

  include Services::Publisher

  attr_accessor :subscriptions, :shutdown, :server

  def run
    thread = Thread.new do
      self.subscriptions = {}
      self.shutdown = false
      until shutdown do
        response = faraday.get('/api/exchanges')
        exchanges = JSON.parse(response.body)
        exchanges.each do |exchange_data|
          name = exchange_data['name']
          next if name.match(STOPLIST)
          unless subscriptions[name]
            puts "Subscribe to #{name}"
            exchange = channel.fanout(name)
            queue = channel.queue('', exclusive: true)
            queue.bind(exchange)
            queue.subscribe do |info, prop, body|
              publish x: 'visualizer', observed: { x: name }
            end
            self.subscriptions[name] = true
          end
        end
        sleep DELAY
      end
    end

    self.server = Thin::Server.new(WEB_HOST, WEB_PORT, handler)
    server.start

    thread.join
  end

  def handler
    lambda do |env|
      [200, {}, template]
    end
  end

  def template
    @template ||= File.read(__FILE__).split('__END__').last
  end

  def faraday
    @faraday ||= Faraday.new(url: ENDPOINT) do |f|
      f.use Faraday::Request::BasicAuthentication, 'guest', 'guest'
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end
  end

  # FIXME this is never called
  def stop
    puts 'Shutting down...'
    self.shutdown = true
    server.stop
  end

end

__END__
<html>
  <body>
   <div id='graph'>hello</div>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.14/d3.min.js"></script>
    <script type='text/javascript'>
      // TODO make is subscribe to exchange 'visualizer' via web stomp
    </script>
  </body>
<html>
