class RackInfo < Struct.new(:app)

  def call(env)
    return app.call(env) unless env['PATH_INFO'] == '/rack-info'

    # toggle monitoring
    Monitoring.running? ? Monitoring.stop : Monitoring.start

    [ 200, {}, ["pid #{$$}, monitoring: #{Monitoring.running?}"] ]
  end

end
