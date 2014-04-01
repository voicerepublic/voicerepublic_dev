# Run with: rackup faye.ru -s thin -E production
require "faye"

Faye::WebSocket.load_adapter('thin')

faye = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)

faye.bind(:publish) do |client_id, channel, data|
  puts "publish #{client_id} #{channel} #{data.inspect}"
end
faye.bind(:subscribe) do |client_id, channel|
  puts "subscribe #{client_id} #{channel}"
end

run faye
