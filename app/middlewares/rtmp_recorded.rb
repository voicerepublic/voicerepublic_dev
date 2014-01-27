# The payload of the post to this middleware will provide the following
# params in `env['rack.request.form_hash']`:
#
# { "app"        => "recordings",
#   "flashver"   => "LNX 11,2,202,310",
#   "swfurl"     => "http://0.0.0.0:3001/Blackbox.swf",
#   "tcurl"      => "rtmp://0.0.0.0/recordings",
#   "pageurl"    => "http://0.0.0.0:3001/soundcheck.html",
#   "addr"       => "127.0.0.1",
#   "call"       => "connect",
#   "path        => "recordings/asdf-12345654321.flv" }
#
class RtmpRecorded < Struct.new(:app, :opts)
  
  def call(env)
    return app.call(env) unless env['PATH_INFO'] == '/rtmp/recorded' and
      env['REQUEST_METHOD'] == 'POST'

    params = env['rack.request.form_hash']
    path = params['path']

    # at this point we know that `path` is done recording we could issue a 
    Delayed::Job

    [ 200, {}, [] ] # all good
  end
  
end
