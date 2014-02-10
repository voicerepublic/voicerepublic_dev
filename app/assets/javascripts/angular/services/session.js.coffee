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
  onair = false

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
      # onListening: ->
      #   upstream.put 'listening', user: { id: config.user_id }
      # onOnAir: ->
      #   onair = true
      # onHosting: ->
      #   onair = true
      # onafterOnAir: ->
      #   onair = false
      # onWaitingForPromotion: ->
      #   upstream.put 'WaitingForPromotion'

  reportState = (state) ->
    $log.info "reporting new state: #{state}"
    upstream.put state, user: { id: config.user_id }

  promote = (name) ->
    for id, user of users when user.name == name
      upstream.put 'promote', id: user.id
  demote = (name) ->
    for id, user of users when user.name == name
      upstream.put 'demote', id: user.id

  guests = ->
    (user for id, user of users when user.role == 'guest')
  participants = ->
    (user for id, user of users when user.role == 'participant')

  # The pushMsgHandler is where the push notifications end up.
  #
  # For now all messages are publicly communicated, so the pushMsgHandler
  # has to check whether the event is addressed to the current user
  # and thus has to be handled differently.
  #
  # unpack, guard, delegate and trigger refresh
  pushMsgHandler = (data) ->
    $log.debug data
    data = data.data # unpack private_pub message
    if data.command == undefined # guard
      return $log.info 'Ignoring malformed message.'
    if data.id = config.user_id # delegate # FIXME = should be ==
      egoMsgHandler data
    else
      othersMsgHandler data
    $rootScope.$apply() # trigger refresh

  # It's the egoMsgHandlers responsibility to trigger events
  # on the state machine, which in turn will create upstream
  # notifications as a side effect.
  egoMsgHandler = (data) ->
    switch data.command
      when 'Registering' then fsm.Registered()
      when 'Listening' then ;
      when 'WaitingForPromotion' then ;
      when 'Promotion' then fsm.Promoted() # external event
      when 'Demotion' then fsm.Demoted() # external event
      else $log.info "Unknown event command: #{data.command}"

  othersMsgHandler = (data) ->
    switch data.command
      when 'Registering' then users[data.user.id] = data.user
      when 'Listening' then ;
      when 'WaitingForPromotion' then ;
      #when 'promote' then users[data.id].role = 'guest'
      #when 'demote' then users[data.id].role = 'participant'
      else $log.info "Unknown event command: #{data.command}"


  privatePub.subscribe "/#{config.namespace}/public", pushMsgHandler
  # privatePub.subscribe "/#{config.namespace}/private/#{name}", dataHandler

  #setTimeout (-> upstream.put 'register', user: { id: config.user_id }), 1000

  # expose
  {
    onair
    name: config.fullname
    fsm 
    promote
    demote
    guests
    participants
  }
