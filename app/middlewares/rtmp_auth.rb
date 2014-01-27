# RTMP Auth Rack Middleware
# -------------------------
#
# The rtmp server will POST to this middleware to either accept or
# decline incoming connects. It will accepts incoming connections if 
# this middleware returns status code 200. It will decline connections
# if it returns a redirect (30x).
#
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
#   "action"     => "rtmpauth",
#   "controller" => "api" }
#
class RtmpAuth < Struct.new(:app, :opts)
  
  def call(env)
    return @app.call unless env['PATH_INFO'] == '/rtmpauth' and
      env['REQUEST_METHOD'] == 'POST'

    # TODO only accept connections from our rtmp servers, to prevent brute forcing
    params = env['rack.request.form_hash']

    return [ 302, {}, [] ] unless params['swfurl'] =~ '/Blackbox.swf'

    [ 200, {}, [] ] # access granted
  end
  
end
