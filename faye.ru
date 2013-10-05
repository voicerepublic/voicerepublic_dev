# Run with: rackup faye.ru -s thin -E production
require "faye"

Faye::WebSocket.load_adapter('thin')

run Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
