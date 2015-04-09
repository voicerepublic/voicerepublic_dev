# A generic middleware to track callbacks from rtmp server,
# it's build for speed to not slow the streaming server down.
#
# For now, it simply logs to its own logfile, but it could...
#
#  * write a journal of the events of a talk
#  * write a manifest for easy stream merging
#  * issue delayed jobs, e.g. kick off transcoding
#  * track presence of users
#  * probably more
#
# The calls being send in the order of the life cycle
#
#  * publish
#  * play
#  * update_publish
#  * update_play
#  * play_done
#  * done
#  * publish_done
#  * done (another done here)
#  * record_done
#
# Common params are, e.g.
#
#   { "app"      => "record",
#     "flashver" => "LNX 11,2,202,310",
#     "swfurl"   => "http://0.0.0.0:3001/Blackbox.swf",
#     "tcurl"    => "rtmp://0.0.0.0/record",
#     "pageurl"  => "http://0.0.0.0:3001/soundcheck.html",
#     "addr"     => "127.0.0.1",
#     "call"     => "publish",
#     "name"     => "asdf",
#     "type"     => "live" }
#
# For call specific params check the docs at
#
#   https://github.com/arut/nginx-rtmp-module/wiki/Directives#notify
#
require 'logger'

class RtmpNotifications

  attr_accessor :app, :opts, :logger

  def initialize(app, opts={})
    self.app, self.opts = app, opts
    log = 'log/rtmp_notifications.log'
    file = File.open(Rails.root.join(log), 'a')
    file.sync = true if Rails.env.development?
    self.logger = Logger.new(file)
  end

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'POST'
    return app.call(env) unless env['PATH_INFO'] == '/rtmp/notify'

    params = env['rack.request.form_hash']
    call = params['call']

    return send(call, params) if respond_to?(call)

    logger.info(params.inspect) if opts[:log]
    Faye.publish_to '/notifications', params

    [ 200, {}, [] ] # all good
  end

  # This is example...
  #
  # def record_done(params)
  #   if params['app'] == 'record'
  #     # TODO write params['path'] to manifest for transcoding
  #   end
  # end

end
