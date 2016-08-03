class IcecastEndpoint < Struct.new(:app, :opts)

  ROUTE = %r{/icecast/(\w+)/([\w-]+)}

  OK               = [200, {}, ['200 - OK']]
  NOT_FOUND        = [404, {}, ['404 - Not found']]
  COMPUTER_SAYS_NO = [740, {}, ['740 - Computer says no']]

  def call(env)
    path = env['PATH_INFO']

    return app.call(env) unless env['REQUEST_METHOD'] == 'POST'
    return app.call(env) unless path.match(%r{\A/icecast/})

    _, action, token = path.match(ROUTE).to_a
    return app.call(env) unless _

    json = env['rack.input'].read
    return OK if action == 'stats' && !json.match(/"source"/)

    venue = Venue.find_by(client_token: token)
    return NOT_FOUND if venue.nil?


    case action.to_sym
    when :ready
      venue.public_ip_address = Settings.icecast.url.host ||
                                JSON.parse(json)['public_ip_address']
      return COMPUTER_SAYS_NO if venue.public_ip_address.nil?
      venue.complete_provisioning!

    when :connect
      venue.connect! unless venue.connected?

    when :disconnect
      venue.disconnect! if venue.can_disconnect?

    when :synced
      venue.synced!

    when :stats
      source = JSON.parse(json)['icestats']['source']
      stats = {
        bitrate: source['audio_bitrate'],
        listener_count: source['listeners'],
        listener_peak: source['listener_peak']
      }
      StreamStat.create(stats.merge(venue_id: venue.id))
      Faye.publish_to venue.channel, event: 'stats', stats: stats
      Faye.publish_to '/admin/stats', stats: stats, slug: venue.slug
      return OK

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
