class RackInfo < Struct.new(:app)

  def call(env)
    return app.call(env) unless env['PATH_INFO'] == '/rack-info'

    [ 200, {}, ["pid #{$$}"] ]
  end

end
