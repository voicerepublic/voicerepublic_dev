class LivepageConfig < Struct.new(:talk, :user)

  #include ActionView::Helpers::AssetUrlHelper

  def to_json
    return JSON.pretty_generate(to_hash) if Rails.env.development?
    to_hash.to_json
  end

  def to_hash
    {
      # user
      user: user_details,
      initial_state: initial_state(user_details[:role]),
      statemachine: statemachine,
      # talk
      talk_id: talk.id,
      host: talk.user.name,
      title: talk.title,
      teaser: talk.teaser,
      session: talk.session || {},
      talk: {
        state: talk.state,
        remaining_seconds: talk.remaining_seconds,
        starts_in: talk.starts_in,
        ends_in: talk.ends_in,
        links: talk.media_links,
        duration: talk.duration.minutes,
        channel: talk.public_channel
      },
      starts_at: talk.starts_at.to_i,
      ends_at: talk.ends_at.to_i,
      # faye
      fayeClientUrl: PrivatePub.config[:server] + '/client.js',
      fayeUrl: PrivatePub.config[:server],
      subscriptions: subscriptions,
      # streams
      namespace: "t#{talk.id}",
      # misc
      fullname: user.name,
      user_id: user.id,
      handle: "u#{user.id}",
      role: user_details[:role], # TODO: remove in favor of user.role
      stream: stream,
      streaming_server: Settings.rtmp.record,
      discussion: discussion,
      guests: talk.guests.map { |g| g.details_for(talk) },
      participants: talk.venue.users.map { |g| g.details_for(talk) },
      blackbox: Settings.blackbox,
      loopback: talk.venue.opts.loopback,
      safetynet_warning: I18n.t('safetynet_warning'),
      blackbox_path: blackbox_path,
      t: {
        minutes: I18n.t('talks.show.minutes'),
        days: I18n.t('talks.show.days')
      }
    }
  end

  def stream
    "t#{talk.id}-u#{user.id}"
  end

  def blackbox_path
    glob = Rails.root.join(File.join(%w(public flash Blackbox*.swf)))
    "/flash/" + File.basename(Dir.glob(glob).first)
  end

  def discussion
    # TODO this might benefit from eager loading
    talk.messages.order('created_at DESC').map do |message|
      {
        # TODO this could use some optimization, by looking up user in
        # angular instead of passing lots of redundant data
        user: message.user.details_for(talk),
        content: message.content,
        created_at: I18n.l(message.created_at, format: :short)
      }
    end
  end

  def user_details
    @user_details ||= user.details_for(talk)
  end

  def initial_state(role)
    return 'Loitering' unless talk.prelive? or talk.halflive? or talk.live?
    case role
    when :host then 'HostRegistering'
    when :guest then 'GuestRegistering'
    else 'Registering'
    end
  end

  def subscriptions
    channels = [ talk.public_channel,
                 user_details[:channel],
                 "/stat/#{stream}" ]

    channels.inject({}) do |r, c|
      r.merge c => PrivatePub.subscription(channel: c)
    end
  end

  def statemachine_spec
    # events in 'Simple Past', states in 'Present Progressive'
    #
    # from-state         -> transition         -> to-state
    <<-EOF
      Registering        -> Registered         -> Waiting
      Waiting            -> TalkStarted        -> Listening
      Listening          -> MicRequested       -> ExpectingPromotion
      ExpectingPromotion -> Promoted           -> OnAir
      ExpectingPromotion -> MicRequestCanceled -> Listening
      Listening          -> Promoted           -> AcceptingPromotion
      AcceptingPromotion -> PromotionAccepted  -> OnAir
      AcceptingPromotion -> PromotionDeclined  -> Listening
      OnAir              -> Demoted            -> Listening
      GuestRegistering   -> Registered         -> OnAir
      HostRegistering    -> Registered         -> HostOnAir
      *                  -> TalkEnded          -> Loitering
    EOF
  end

  def statemachine
    statemachine_spec.split("\n").map do |transition|
      from, name, to = transition.split('->').map(&:strip)
      { name: name, from: from, to: to }
    end
  end

end
