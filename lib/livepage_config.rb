class LivepageConfig < Struct.new(:talk, :user)
  
  def to_json
    return JSON.pretty_generate(to_hash) if Rails.env.development?
    to_hash.to_json
  end

  def to_hash
    {
      fayeClientUrl: 'http://kluuu.com:9293/faye/client.js',
      fayeUrl: 'http://kluuu.com:9293/faye',
      timestamp: 1302306682972,
      signature: '123',
      namespace: 'talk123',
      role: role,
      statemachine: statemachine[role.to_sym]
    }
  end

  def role
    return :host if user == talk.user
    return :guest if true == false # FIXME
    :listener
  end

  def statemachine
    { 
      host: 
      [ { name: 'Initialized', from: 'Initializing', to: 'SoundChecking' },
        { name: 'SucceededSoundCheck', from: 'SoundChecking', to: 'Hosting' } ],
      guest:
      [ { name: 'Initialized', from: 'Initializing', to: 'SoundChecking' },
        { name: 'SucceededSoundCheck', from: 'SoundChecking', to: 'OnAir' },
        { name: 'Demoted', from: 'OnAir', to: 'ListeningButReady'},
        { name: 'Promoted', from: 'ListeningButReady', to: 'OnAir' } ],
      listener:
      [ { name: 'Initialized', from: 'Initializing', to: 'Listening' },
        { name: 'MicRequested', from: 'Listening', to: 'ColdSoundChecking' },
        { name: 'SucceededColdSoundCheck',
          from: 'ColdSoundChecking', to: 'WaitingForPromotion' },
        { name: 'Promoted', from: 'WaitingForPromotion', to: 'OnAir' },
        { name: 'Promoted', from: 'Listening', to: 'HotSoundChecking' },
        { name: 'SucceededHotSoundCheck', from: 'HotSoundChecking', to: 'OnAir' },
        { name: 'Demoted', from: 'OnAir', to: 'ListeningButReady' },
        { name: 'Promoted', from: 'ListeningButReady', to: 'OnAir' } ]
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

