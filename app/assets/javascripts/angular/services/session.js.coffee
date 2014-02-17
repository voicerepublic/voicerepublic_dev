# The SessionService is the single source for insession
# data and contains the session logic.
#
# CHECK Maybe it makes sense to split this further into
#  * stuff that belongs to the user
#  * stuff that belongs to the whole session (all users)
Livepage.factory 'session', ($log, privatePub, util, $rootScope,
                             $timeout, upstream, config, blackbox,
                             $interval) ->

  users = {}
  blackbox.setStreamingServer config.streaming_server
  config.onair = false

  subscribeAllStreams = ->
    for id, user of users
      if user.state in ['OnAir', 'Hosting']
        unless id is "#{config.user_id}"
          blackbox.subscribe user.stream

  fsm = StateMachine.create
    initial: config.initial_state
    events: config.statemachine
    callbacks:
      onenterstate: (event, from, to) ->
        # FIXME the timeout is a hack!
        switch to
          when 'Registering', 'GuestRegistering', 'HostRegistering'
            $timeout (-> reportState(to)), 1000
          else
            reportState(to)
      onListening: ->
        subscribeAllStreams()
      onOnAir: ->
        blackbox.publish config.stream
        config.onair = true
      onHosting: ->
        users = config.session
        blackbox.publish config.stream
        config.onair = true
      onafterOnAir: ->
        blackbox.unpublish()
        config.onair = false

  reportState = (state) ->
    $log.info "reporting new state: #{state}"
    upstream.state state

  promote = (id) ->
    $log.debug "promote #{id}"
    upstream.event 'Promote', user: { id }
  demote = (id) ->
    return fsm.Demoted() if id is config.user_id
    upstream.event 'Demote', user: { id }

  onair = ->
    (user for id, user of users when user.state == 'OnAir')
  listening = ->
    (user for id, user of users when user.state in ['Listening', 'ListeningOnStandby'])
  waitingForPromotion = ->
    (user for id, user of users when user.state == 'ExpectingPromotion')

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
    #$log.debug 'Receiving...'
    #$log.debug data
    method = data.state || data.event
    if method == undefined # guard
      return $log.info 'Ignoring malformed message. ' +
        'Neither state nor event given.'
    if data.user?.id == config.user_id
      egoMsgHandler method, data
    else
      stateHandler method, data if data.state
      eventHandler method, data if data.event
    #$log.debug 'trigger refresh'
    $rootScope.$apply()

  # It's the egoMsgHandlers responsibility to trigger events
  # on the state machine, which in turn will create upstream
  # notifications as a side effect.
  egoMsgHandler = (method, data) ->
    switch method
      when 'Registering', 'GuestRegistering', 'HostRegistering'
        fsm.Registered()
        users[data.user.id] = data.user
      when 'Waiting'
        if config.talk.state == 'live'
          # TODO pull session info
          fsm.TalkStarted()
      when 'Promote' then fsm.Promoted() # external event
      when 'Demote' then fsm.Demoted() # external event
      else $log.info "Ignore: #{method}"
    # store the current state on the users hash
    users[data.user.id].state = fsm.current

  stateHandler = (state, data) ->
    users[data.user.id]?.state = state
    switch state
      when 'Registering'
        users[data.user.id] = data.user
      when 'OnAir', 'Hosting'
        if isListening()
          blackbox.subscribe users[data.user.id].stream

  eventHandler = (event, data) ->
    switch event
      when 'StartTalk'
        config.talk.state = 'live'
        unless fsm.is('HostOnAir')
          users = data.session
          fsm.TalkStarted()
      when 'EndTalk'
        fsm.TalkEnded()

  startTalk = ->
    upstream.event 'StartTalk'
  endTalk = ->
    upstream.event 'EndTalk'

  privatePub.subscribe "/#{config.namespace}/public", pushMsgHandler
  # privatePub.subscribe "/#{config.namespace}/private/#{name}", dataHandler

  { # expose
    # -- events
    promote
    demote
    startTalk
    endTalk
    # --- groups
    onair
    listening
    waitingForPromotion
    # -- misc
    name: config.fullname
    fsm
    users # debug
    isListening
    countdown: config.countdown
  }
