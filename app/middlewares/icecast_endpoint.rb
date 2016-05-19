class IcecastEndpoint < Struct.new(:app, :opts)

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'POST'
    return app.call(env) unless env['PATH_INFO'].match(%r{\A/icecast/})

    json = env['rack.input'].read
    # workaround malformed json posted by icecast
    json = json.sub('",}', '"}')
    payload = JSON.parse(json)

    if env['PATH_INFO'].match(%r{^/icecast/stats/([\w-]+)$})
      venue = Venue.find_by(client_token: $1)
      source = payload['icestats']['source']
      stats = {
        bitrate: source['audio_bitrate'],
        listener_count: source['listeners'],
        listener_peak: source['listener_peak']
      }
      Faye.publish_to venue.channel, event: 'stats', stats: stats
      return [ 200, {}, [] ]
    end


    client_token = payload['client_token']

    return [ 740, {}, ['740 - Computer says no'] ] if client_token.nil?

    venue = Venue.find_by(client_token: client_token)
    return [ 404, {}, [] ] unless venue.present?

    # pp env

    case env['PATH_INFO']
    when '/icecast/complete'
      # raise "wtf" if env['REMOTE_ADDR'] != payload['public_ip_address']
      venue.public_ip_address = Settings.icecast.url.host || payload['public_ip_address']
      venue.complete_provisioning!

    when '/icecast/connect'
      venue.connect!

    when '/icecast/disconnect'
      venue.disconnect!

    when '/icecast/synced'
      venue.synced!

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
