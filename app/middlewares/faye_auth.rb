class FayeAuth < Struct.new(:app, :opts)

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'POST'
    return app.call(env) unless env['PATH_INFO'] == '/faye/auth'

    req = Rack::Request.new(env)

    response = req.params['messages'].values.map do |message|
      #unless current_user.can?(:read, message[:channel])
      #  next message.merge(error: 'Forbidden')
      #end
      message.merge(signature: Faye::Authentication.sign(message, opts[:secret]))
    end

    [ 200, {}, [ {signatures: response}.to_json ] ] # access granted
  end

end
