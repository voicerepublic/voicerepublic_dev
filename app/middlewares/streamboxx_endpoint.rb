class StreamboxxEndpoint < Struct.new(:app, :opts)

  ROUTE = %r{/streamboxx/(\w+)/(\w+)}

  OK               = [200, {}, ['200 - OK']]
  NOT_FOUND        = [404, {}, ['404 - Not found']]
  COMPUTER_SAYS_NO = [740, {}, ['740 - Computer says no']]

  def call(env)
    path = env['PATH_INFO']

    return app.call(env) unless env['REQUEST_METHOD'] == 'POST'
    return app.call(env) unless path.match(%r{\A/streamboxx/})

    _, identifier, action = path.match(ROUTE).to_a
    return app.call(env) unless _

    device = Device.find_by(identifier: identifier)
    return NOT_FOUND if device.nil?

    device.events.create! name: action

    case action.to_sym
    when :liquidsoap_startup
    when :liquidsoap_shutdown
    when :icecast_connect
    when :icecast_disconnect
    when :icecast_error
    when :icecast_start
    when :icecast_stop
    when :file_start
    when :file_stop
    when :file_close
    else
      return [ 721, {}, ['721 - Known Unknowns', path] ]
    end

    Rails.logger.info '-> 200 OK'
    OK

    #for now remove the catch all errors here
    # rescue => e
    # Rails.logger.error(([e.message]+e.backtrace) * "\n")
    #  [ 722, {}, ['722 - Unknown Unknowns', e.message] ]
  end

end
