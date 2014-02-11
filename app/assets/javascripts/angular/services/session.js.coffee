# The SessionService is the single source for insession
# data and contains the session logic.
#
# CHECK Maybe it makes sense to split this further into
#  * stuff that belongs to the user 
#  * stuff that belongs to the whole session (all users)
Livepage.factory 'session', ($log, privatePub, util, $rootScope,
                             $timeout, upstream, config, blackbox) ->

  users = config.session || {}

  id = config.user_id
  config.onair = false

  fsm = StateMachine.create
    initial: 'Registering'
    events: config.statemachine
    callbacks:
      onenterstate: (event, from, to) ->
        # FIXME the timeout is a hack!
        if to == 'Registering'
          $timeout (-> reportState(to)), 1000
        else
          reportState(to)
      # onSoundChecking: ->
      #   alert 'soundcheck'
      #   fsm.SucceededSoundCheck()
      onListening: ->
        config.onair = false
      onListeningButReady: ->
        config.onair = false
      onOnAir: ->
        config.onair = true
      onHosting: ->
        config.onair = true
      # onafterOnAir: ->
      #   onair = false
      # onWaitingForPromotion: ->
      #   upstream.put 'WaitingForPromotion'

  reportState = (state) ->
    $log.info "reporting new state: #{state}"
    upstream.state config.user_id, state

  # TODO change name to id
  promote = (name) ->
    for id, user of users when user.name == name
      upstream.event user.id, 'Promotion'
  demote = (name) ->
    for id, user of users when user.name == name
      upstream.event user.id, 'Demotion'

  guests = ->
    (user for id, user of users when user.state == 'OnAir')
  participants = ->
    (user for id, user of users when user.state in ['Listening', 'ListeningButReady'])

  isListening = ->
    (fsm.current in ['Listening', 'ListeningButReady'])

  # The pushMsgHandler is where the push notifications end up.
  #
  # For now all messages are publicly communicated, so the pushMsgHandler
  # has to check whether the event is addressed to the current user
  # and thus has to be handled differently.
  #
  # unpack, guard, delegate and trigger refresh
  pushMsgHandler = (data) ->
    data = data.data # unpack private_pub message
    $log.debug 'Receiving...'
    $log.debug data
    method = data.state || data.event
    if method == undefined # guard
      return $log.info 'Ignoring malformed message. ' +
        'Neither state nor event given.'
    if data.user.id == config.user_id
      egoMsgHandler method, data
    else
      otherMsgHandler method, data
    $log.debug 'trigger refresh'
    $rootScope.$apply()

  # It's the egoMsgHandlers responsibility to trigger events
  # on the state machine, which in turn will create upstream
  # notifications as a side effect.
  egoMsgHandler = (method, data) ->
    switch method
      when 'Registering'
        fsm.Registered()
        users[data.user.id] = data.user
      when 'Promotion' then fsm.Promoted() # external event
      when 'Demotion' then fsm.Demoted() # external event
      else $log.info "EgoIgnoring: #{method}"
    # store the current state on the users hash
    users[data.user.id].state = fsm.current

  otherMsgHandler = (method, data) ->
    switch method
      when 'Registering' then users[data.user.id] = data.user
      when 'Listening' then users[data.user.id].state = 'Listening'
      when 'OnAir' then users[data.user.id].state = 'OnAir'
      when 'ListeningButReady' then users[data.user.id].state = 'ListeningButReady'
      # else $log.info "OtherIgnoring: #{method}"

  privatePub.subscribe "/#{config.namespace}/public", pushMsgHandler
  # privatePub.subscribe "/#{config.namespace}/private/#{name}", dataHandler

  { # expose
    name: config.fullname
    fsm 
    promote
    demote
    guests
    participants
    users # debug
    isListening
  }
