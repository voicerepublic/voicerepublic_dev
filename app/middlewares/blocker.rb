# TODO read disallowed useragent/path combinations from robots.txt
# and check all, rename this class to EnforceRobotsTxt and publish
#
# There 704 (Goto Fail) error code was taken from
#
#     https://github.com/joho/7XX-rfc
#
class Blocker < Struct.new(:app, :opts)

  def call(env)
    return app.call(env) unless env['HTTP_USER_AGENT'] and
      env['HTTP_USER_AGENT'].match(/EasouSpider/)
    
    [ 704, {"Content-Type" => "text/html"},
      [ "<h1>704 Goto Fail</h1>",
        "<p>Next time respect /robots.txt</p>" ] ]
  end

end
