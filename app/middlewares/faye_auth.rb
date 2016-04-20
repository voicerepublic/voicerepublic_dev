# Sample channels
#
# * /t1048/public
# * /t1048/u1
# * /stat/t1048-u1
#
class FayeAuth < Struct.new(:app, :opts)

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'POST'
    return app.call(env) unless env['PATH_INFO'] == '/faye/auth'

    # dump rack env (I left this here for future reference.)
    # File.open("/tmp/rack_env","w") { |f| PP.pp(env,f) }

    req = Rack::Request.new(env)
    msgs = req.params['messages']

    resp = msgs.values.map do |msg|
      # ok, let's see what the user wants to have access to
      case msg['channel']

      # NEWSCHOOL
      when %r{/down/venue/(\d+)$}
        if user = env['warden'].user
          venue = Venue.find($1)
          if venue and venue.user_id == user.id
            msg.merge signature: Faye::Authentication.sign(msg, opts[:secret])
          else
            msg.merge error: 'Forbidden'
          end
        else
          msg.merge error: 'Forbidden'
        end

      # OLDSCHOOL
      when %r{/public$} # a public channel
        msg.merge signature: Faye::Authentication.sign(msg, opts[:secret])

      when /u(\d+)$/ # a private channel
        if user = env['warden'].user # if it's a real user
          if $1.to_i == user.id # and the user is the owner of the channel
            msg.merge signature: Faye::Authentication.sign(msg, opts[:secret])
          else
            # if not, then someting malicious is going on
            msg.merge error: 'Forbidden'
          end
        else
          # if it's not a real user, aka a anonymous user, we don't need
          # the channel anyways, we might as well not even try to subscribe
          msg.merge error: 'Forbidden'
        end
      end
    end

    [ 200, {}, [ { signatures: resp }.to_json ] ]
  end

end
