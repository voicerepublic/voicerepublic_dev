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

    user = env['warden'].user
    req = Rack::Request.new(env)
    msgs = req.params['messages']

    resp = msgs.values.map do |msg|
      if msg['channel'].match(/(\/public|u#{user.id})$/)
        msg.merge signature: Faye::Authentication.sign(msg, opts[:secret])
      else
        msg.merge error: 'Forbidden'
      end
    end

    [ 200, {}, [ { signatures: resp }.to_json ] ]
  end

end
