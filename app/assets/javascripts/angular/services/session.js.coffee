# The SessionService is the single source for insession
# data and contains the session logic.
#
# CHECK Maybe it makes sense to split this further into
#  * stuff that belongs to the user 
#  * stuff that belongs to the whole session (all users)
Livepage.factory 'session', ($log, privatePub, util, $rootScope,
                                    upstream, config, blackbox) ->

  name = "noname#{Math.round(Math.random()*1000)}"
  role = 'participant'

  # demo data, this data object is hidden via closures
  # this data will eventually be provided by faye
  # which will act as a dependency to this service
  session =
    me: {
      name: name
      role: 'participant'
      image: "http://lorempixel.com/80/80/people/#{Math.round(Math.random()*9)+2}/"
    }
    users: {
      # 1: { name: 'Bob',  role: 'participant' },
      # 2: { name: 'Jim',  role: 'participant' },
      # 3: { name: 'Mary', role: 'guest' }
    }

  onair = true # false

  # events in 'Simple Past', states in 'Present Progressive'
  fsm = StateMachine.create
    initial: 'Initializing'
    events: [
      # Host
      { name: 'HostInitialized',          from: 'Initializing',        to: 'HostSoundChecking' },
      { name: 'SucceededHostSoundCheck',  from: 'HostSoundChecking',   to: 'Hosting' },
      # Guest
      { name: 'GuestInitialized',         from: 'Initializing',        to: 'GuestSoundChecking' },
      { name: 'SucceededGuestSoundCheck', from: 'GuestSoundChecking',  to: 'OnAir' },
      # Listener
      { name: 'ListenerInitialized',      from: 'Initializing',        to: 'Listening' },
      # MicRequest/Promote
      { name: 'MicRequested',             from: 'Listening',           to: 'ColdSoundChecking' },
      { name: 'SucceededColdSoundCheck',  from: 'ColdSoundChecking',   to: 'WaitingForPromotion' },
      { name: 'Promoted',                 from: 'WaitingForPromotion', to: 'OnAir' },
      { name: 'Promoted',                 from: 'Listening',           to: 'HotSoundChecking' },
      { name: 'SucceededHotSoundCheck',   from: 'HotSoundChecking',    to: 'OnAir' },
      # Demote
      { name: 'Demoted',                  from: 'OnAir',               to: 'Listening' }
    ]
    callbacks:
      onOnAir: ->
        onair = true
      onHosting: ->
        onair = true
      onafterOnAir: ->
        onair = false

  promote = (name) ->
    for id, user of session.users when user.name == name
      upstream.update user.name, role: 'guest'
  demote = (name) ->
    for id, user of session.users when user.name == name
      upstream.update user.name, role: 'participant'

  # filter user array. this should be an angular filter.
  # it still works, though. this is fuckin' magic!
  guests = ->
    (user for id, user of session.users when user.role == 'guest')
  participants = ->
    (user for id, user of session.users when user.role == 'participant')

  processEvent = (event) ->
    switch event.name
      when 'promote' then session.users[event.user].role = 'guest'
      when 'demote' then session.users[event.user].role = 'participant'
      when 'register'
        # merge new user into session and send session back to user
      else $log.error "Unknown event: #{event.name}"

  dataHandler = (data) ->
    $log.info data
    switch data.type
      when 'full' then session = data.data
      when 'diff' then util.merge session, data.data
      when 'event' then processEvent data.event
      else $log.error "Unknown data type: #{data.type}"
    $rootScope.$apply()

  privatePub.subscribe "/#{config.namespace}/public", dataHandler
  privatePub.subscribe "/#{config.namespace}/private/#{name}", dataHandler

  upstream.register({ name })

  # expose
  {
    onair
    name
    role
    fsm 
    promote
    demote
    guests
    participants
    session
  }
