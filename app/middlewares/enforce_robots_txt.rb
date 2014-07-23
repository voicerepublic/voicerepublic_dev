# Reads and parses the robots txt given by the option `source`
# and enforces the rule by responding with an error if a rule
# applies for the incoming request.
#
# The `704 Goto Fail` error code was taken from
#
#     https://github.com/joho/7XX-rfc
#
# TODOs might include
# * dealing with proper url encoding
# * dealing with wildcard matchers
#
class EnforceRobotsTxt < Struct.new(:app, :opts)

  def call(env)
    # skip all tests
    return app.call(env) if env['HTTP_USER_AGENT'].nil?

    robots_txt.each do |ua, paths|
      if env['HTTP_USER_AGENT'].include?(ua)
        if env['PATH_INFO'].start_with?(*paths)
          return [ 704, {"Content-Type" => "text/html"},
                   [ "<h1>704 Goto Fail</h1>",
                     "<p>Next time respect /robots.txt</p>" ] ]
        end
      end
    end
    
    app.call(env)
  end

  private
  
  def robots_txt
    @robots_txt ||= File.read(opts[:source]).split.inject([]) do |result, line|
      case line
      when /User-agent:\s*(.+)\s*$/ then result << [$1, []]
      when /Disallow:\s*(.+)\s*$/ then result.last.last << $1
      end
      result
    end
  end
  
end
