class LivepageConfig < Struct.new(:talk, :user)
  
  def to_json
    return JSON.pretty_generate(to_hash) if Rails.env.development?
    to_hash.to_json
  end

  def to_hash
    {
      # talk
      talk_id: talk.id,
      host: talk.user.name,
      title: talk.title,
      teaser: talk.teaser,
      session: talk.session,
      # faye
      fayeClientUrl: PrivatePub.config[:server] + '/client.js',
      fayeUrl: PrivatePub.config[:server],
      subscription: subscription,
      # streams
      namespace: "t#{talk.id}",
      # misc
      fullname: user.name,
      user_id: user.id,
      handle: "u#{user.id}",
      role: role,
      statemachine: statemachine[role.to_sym],
      stream: "t#{talk.id}-u#{user.id}",
      streaming_server: Settings.rtmp.record
    }
  end

  def subscription
    PrivatePub.subscription channel: talk.public_channel
  end

  def role
    return :host if user == talk.user
    return :guest if true == false # FIXME
    :listener
  end

  # events in 'Simple Past', states in 'Present Progressive'
  def statemachine
    { 
      host: 
      #[ { name: 'Registered', from: 'Registering', to: 'SoundChecking' },
      #  { name: 'SucceededSoundCheck', from: 'SoundChecking', to: 'Hosting' } ],
      [ { name: 'Registered', from: 'Registering', to: 'Hosting' } ],
      guest:
      [ { name: 'Registered', from: 'Registering', to: 'SoundChecking' },
        { name: 'SucceededSoundCheck', from: 'SoundChecking', to: 'OnAir' },
        { name: 'Demoted', from: 'OnAir', to: 'ListeningButReady'},
        { name: 'Promoted', from: 'ListeningButReady', to: 'OnAir' } ],
      listener:
      [ { name: 'Registered', from: 'Registering', to: 'Waiting' },
        { name: 'StartTalk', from: 'Waiting', to: 'Listening' },
        { name: 'RequestedMic', from: 'Listening', to: 'WaitingForPromotion' },
        { name: 'Promoted', from: 'WaitingForPromotion', to: 'OnAir' },
        { name: 'Promoted', from: 'Listening', to: 'OnAir' },
        { name: 'Demoted', from: 'OnAir', to: 'ListeningButReady' },
        { name: 'Promoted', from: 'ListeningButReady', to: 'OnAir' } ]
      # listener:
      # [ { name: 'Initialized', from: 'Registering', to: 'Listening' },
      #   { name: 'MicRequested', from: 'Listening', to: 'ColdSoundChecking' },
      #   { name: 'SucceededColdSoundCheck',
      #     from: 'ColdSoundChecking', to: 'WaitingForPromotion' },
      #   { name: 'Promoted', from: 'WaitingForPromotion', to: 'OnAir' },
      #   { name: 'Promoted', from: 'Listening', to: 'HotSoundChecking' },
      #   { name: 'SucceededHotSoundCheck', from: 'HotSoundChecking', to: 'OnAir' },
      #   { name: 'Demoted', from: 'OnAir', to: 'ListeningButReady' },
      #   { name: 'Promoted', from: 'ListeningButReady', to: 'OnAir' } ]
    }
  end

end

  # copy and pasted from old venue
  # # this is rendered as json in venue/venue_show_live
  # def details_for(user)
  #   {
  #     streamId: "v#{id}-e#{current_event.id}-u#{user.id}",
  #     channel: story_channel,
  #     role: (self.user == user) ? 'host' : 'participant',
  #     storySubscription: PrivatePub.subscription(channel: story_channel),
  #     backSubscription: PrivatePub.subscription(channel: back_channel),
  #     chatSubscription: PrivatePub.subscription(channel: channel_name),
  #     streamer: (current_event.record ? STREAMER_CONFIG['recordings'] : STREAMER_CONFIG['discussions'])
  #   }
  # end

