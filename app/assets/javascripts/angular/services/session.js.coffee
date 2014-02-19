# The SessionService is the single source for insession
# data and contains the session logic.
#
Livepage.factory 'session', ($log, privatePub, util, $rootScope,
                             $timeout, upstream, config, blackbox,
                             $interval) ->

  # reconfigure blackbox
  blackbox.setStreamingServer config.streaming_server

  # initialize defaults
  users = {}
  config.flags =
    onair: false
    reqmic: false
    acceptOrDecline: false

  # some utility functions for the statemachine's callbacks
  subscribeAllStreams = ->
    for id, user of users
      if user.state in ['OnAir', 'Hosting']
        unless id is "#{config.user_id}"
          blackbox.subscribe user.stream

  unsubscribeAllStreams = ->
    # TODO blackbox.unsubscribeAll()

  reportState = (state) ->
    # $log.info "reporting new state: #{state}"
    upstream.state state

  # definition of the state machine, incl. callbacks
  fsm = StateMachine.create
    initial: config.initial_state
    events: config.statemachine
    callbacks:
      onenterstate: (event, from, to) ->
        switch to
          when 'Registering', 'GuestRegistering', 'HostRegistering'
            # FIXME the timeout is a hack! better: wait until subscribed
            $timeout (-> reportState(to)), 2000
          else
            reportState(to)
      onleaveWaiting: ->
        # subscribeStreams (#2)
        subscribeAllStreams()
      onListening: ->
        config.flags.reqmic = true
      onleaveListening: ->
        config.flags.reqmic = false # (#3/5)
        true
      onAcceptingPromotion: ->
        config.flags.acceptOrDecline = true
      onleaveAcceptingPromotion: ->
        config.flags.acceptOrDecline = false
        true
      onOnAir: ->
        # publishStream, showOnAir/UnMute (#4)
        blackbox.publish config.stream
        config.flags.onair = true
      onleaveOnAir: ->
        # unpublishStream, hideOnAir/UnMute (#6)
        blackbox.unpublish()
        config.flags.onair = false
        true
      onHostOnAir: ->
        users = config.session
        # publishStream, showOnAir/UnMute (#1)
        blackbox.publish config.stream
        config.flags.onair = true
      onleaveHostOnAir: ->
        # unpublishStream, hideOnAir/UnMute (#7)
        blackbox.unpublish()
        config.flags.onair = false
        true
      onLoitering: ->
        # unsubscribeStreams (#7)
        unsubscribeAllStreams()

  # comprehending queries on the state
  isNotRegisteringNorWaiting = ->
    !fsm.current.match /(Register|Wait)ing$/

  # the pushMsgHandler is single point of entry for push notifications
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

  # the egoMsgHandlers will trigger transitions and other side
  # effects based on incoming state notifications as well as
  # events. It will only handle messages targeted at it's own user.
  egoMsgHandler = (method, data) ->
    $log.debug "ego: #{method}"
    switch method
      when 'Registering', 'GuestRegistering', 'HostRegistering'
        # merge myself (#14)
        fsm.Registered()
        users[data.user.id] = data.user
      when 'Waiting' # state
        if config.talk.state == 'live'
          # progress (#15)
          # TODO pull session info
          fsm.TalkStarted()
      when 'Promote' # event (#12)
        fsm.Promoted()
      when 'Demote' # event (#12)
        fsm.Demoted()
      # else $log.info "Ignore: #{method}"
    # store the current state on the users hash
    users[data.user.id].state = fsm.current

  # the stateHandler handles the state notification of other users
  stateHandler = (state, data) ->
    $log.debug "user #{data.user.id}: #{state}"
    users[data.user.id]?.state = state
    switch state
      when 'Registering', 'GuestRegistering', 'HostRegistering'
        # mergeUser (#10)
        users[data.user.id] = data.user
      when 'OnAir', 'HostOnAir'
        if isNotRegisteringNorWaiting()
          # subscribeStream (#8)
          blackbox.subscribe users[data.user.id].stream
      when 'Listening'
        if isNotRegisteringNorWaiting()
          # unsubscribeStream (#9)
          # TODO blackbox.unsubscribe users[data.user.id].stream
          ;

  # the eventHandler handles events (as opposed to states)
  eventHandler = (event, data) ->
    $log.debug "event: #{event}"
    switch event
      when 'StartTalk'
        # sendStartTalk (#11)
        config.talk.state = 'live'
        unless fsm.is('HostOnAir')
          users = data.session
          fsm.TalkStarted()
      when 'EndTalk'
        # sendEndTalk (#13)
        fsm.TalkEnded()

  # some methods only available to the host
  promote = (id) ->
    upstream.event 'Promote', user: { id }
  demote = (id) ->
    return fsm.Demoted() if id is config.user_id
    upstream.event 'Demote', user: { id }
  startTalk = ->
    upstream.event 'StartTalk'
  endTalk = ->
    upstream.event 'EndTalk'

  # separate the audience into four groups
  guests = ->
    (user for id, user of users when user.state == 'OnAir')
  expectingPromotion = ->
    (user for id, user of users when user.state == 'ExpectingPromotion')
  acceptingPromotion = ->
    (user for id, user of users when user.state == 'AcceptingPromotion')
  participants = ->
    (user for id, user of users when user.role == 'participant' and
      user.state == 'Listening')
  listeners = ->
    (user for id, user of users when user.role == 'listener')

  # TODO idealy this should move into callback: on/Registering$/
  # subscribe to push notifications
  privatePub.subscribe "/#{config.namespace}/public", pushMsgHandler
  # privatePub.subscribe "/#{config.namespace}/private/#{name}", dataHandler

  # exposed objects
  { 
    # -- events
    promote
    demote
    startTalk
    endTalk
    # --- groups
    guests
    expectingPromotion
    acceptingPromotion
    participants
    # -- misc
    name: config.fullname
    fsm
    users # debug
    countdown: config.countdown
  }
