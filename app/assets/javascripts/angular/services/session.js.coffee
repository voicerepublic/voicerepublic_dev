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
    upstream.state config.user_id, state

  promote = (name) ->
    for id, user of users when user.name == name
      # FIXME
      upstream.event user.id, 'Promotion'
  demote = (name) ->
    for id, user of users when user.name == name
      # FIXME
      upstream.event user.id, 'Demotion'


  guests = ->
    (user for id, user of users when user.state == 'OnAir')
  participants = ->
    (user for id, user of users when user.state == 'Listening')

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
    if data.id = config.user_id # delegate # FIXME = should be ==
      egoMsgHandler method, data
    else
      othersMsgHandler method, data
    $rootScope.$apply() # trigger refresh

  # It's the egoMsgHandlers responsibility to trigger events
  # on the state machine, which in turn will create upstream
  # notifications as a side effect.
  egoMsgHandler = (method, data) ->
    switch method
      when 'Registering' then fsm.Registered()
      when 'Promotion' then fsm.Promoted() # external event
      when 'Demotion' then fsm.Demoted() # external event
      else $log.info "EgoIgnoring: #{method}"

  othersMsgHandler = (method, data) ->
    switch method
      when 'Registering' then users[data.user.id] = data.user
      else $log.info "OtherIgnoring: #{method}"

  privatePub.subscribe "/#{config.namespace}/public", pushMsgHandler
  # privatePub.subscribe "/#{config.namespace}/private/#{name}", dataHandler

  { # expose
    onair
    name: config.fullname
    fsm 
    promote
    demote
    guests
    participants
  }
