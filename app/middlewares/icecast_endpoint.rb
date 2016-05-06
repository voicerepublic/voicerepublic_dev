class IcecastEndpoint < Struct.new(:app, :opts)

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'POST'
    return app.call(env) unless env['PATH_INFO'].match(%r{\A/icecast/})

    payload = JSON.parse(env['rack.input'].read)
    client_token = payload['client_token']

    return [ 740, {}, ['740 - Computer says no'] ] if client_token.nil?

    venue = Venue.find_by(client_token: client_token)
    return [ 404, {}, [] ] unless venue.present?

    # pp env

    case env['PATH_INFO']
    when '/icecast/complete'
      # raise "wtf" if env['REMOTE_ADDR'] != payload['public_ip_address']
      venue.public_ip_address = Settings.icecast.url.host || env['REMOTE_ADDR']
      venue.complete_provisioning!

    when '/icecast/connect'
      venue.connect!

    when '/icecast/disconnect'
      venue.disconnect!

    else
      return [ 721, {}, ['721 - Known Unknowns', env['PATH_INFO']] ]
    end

    Rails.logger.info '200 OK'
    [ 200, {}, [] ]

    #for now remove the catch all errors here
    # rescue => e
    # Rails.logger.error(([e.message]+e.backtrace) * "\n")
    #  [ 722, {}, ['722 - Unknown Unknowns', e.message] ]
  end

end
