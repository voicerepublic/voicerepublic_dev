class IcecastApi < Struct.new(:app, :opts)

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'POST'
    return app.call(env) unless env['PATH_INFO'].match(%r{\A/icecast/})

    payload = JSON.parse(env['rack.input'].read)
    client_token = payload['client_token']

    venue = Venue.find_by(client_token: client_token)
    return [ 404, {}, [] ] unless venue.present?

    case env['PATH_INFO']
    when '/icecast/complete'
      venue.public_ip_address = payload['public_ip_address']
      venue.complete_provisioning!

    when '/icecast/connect'
      venue.connect!

    when '/icecast/disconnect'
      venue.disconnect!

    else
      # TODO log an error
      return [ 404, {}, [] ]
    end

    [ 200, {}, [] ]
  end

end
