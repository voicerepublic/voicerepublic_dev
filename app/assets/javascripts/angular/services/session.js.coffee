# The SessionService is the single source for insession
# data and contains the session logic.
#
sessionFunc = ($log, messaging, util, $rootScope, $timeout,
               config, blackbox) ->

  # reconfigure blackbox
  blackbox.setStreamingServer config.streaming_server

  # initialize defaults
  discussion = config.discussion
  users = config.session
  config.flags =
    onair: false
    reqmic: false
    acceptOrDecline: false
    settings: false
    connecting: true
    blackboxReady: false
  config.feedback = { data: { bw_in: 0 } }
  config.progress = { index: 0, total: 1 }

  # some utility functions for the statemachine's callbacks
  subscribeAllStreams = ->
    $log.debug 'subscribing to all streams...'
    for id, user of users
      if user.state in ['OnAir', 'HostOnAir']
        unless id is "#{config.user_id}"
          $log.debug "subscribe to #{user.name}"
          blackbox.subscribe user.stream

  unsubscribeAllStreams = ->
    blackbox.unsubscribeAll()

  reportState = (state) ->
    # skip reporting of state for anonymous users
    return if config.user.role == 'listener'
    messaging.publish(state: state)

  # definition of the state machine, incl. callbacks
  # https://github.com/jakesgordon/javascript-state-machine/blob/master/README.md
  fsm = StateMachine.create
    initial: config.initial_state
    # events, resp. transitions are defined in lib/livepage_config.rb
    events: config.statemachine
    error: (eventName, from, to, args, errorCode, errorMessage) ->
      $log.error 'Error in State Machine!'
      $log.error [eventName, from, to, args, errorCode]
      $log.error errorMessage
    callbacks:
      onenterstate: (event, from, to) ->
        # $log.info ">> ONENTERSTATE #{event}: #{from} -> #{to}"
        reportState(to)
        true
      # the following 4 callbacks need timeouts to escape from
      # callback context, otherwise, fireing fsm events will raise an
      # error
      onenterRegistering: ->
        $timeout (-> fsm.Registered()), 1
      onenterHostRegistering: ->
        $timeout (-> fsm.Registered()), 1
      onenterGuestRegistering: ->
        $timeout (-> fsm.Registered()), 1
      onenterWaiting: ->
        if config.talk.state == 'live'
          # TODO pull session info
          $timeout (-> fsm.TalkStarted()), 1
      onleaveWaiting: ->
        subscribeAllStreams()
      onleaveHostRegistering: ->
        subscribeAllStreams()
        config.flags.settings = true
      onleaveGuestRegistering: ->
        subscribeAllStreams()
        config.flags.settings = true
      onListening: ->
        unless config.user.role == 'listener'
          config.flags.reqmic = true
      onleaveListening: ->
        config.flags.reqmic = false
        true
      onbeforeMicRequested: ->
        config.flags.settings = true
        blackbox.micCheck()
      onbeforeMicRequestCanceled: ->
        config.flags.settings = false
        true
      onAcceptingPromotion: ->
        config.flags.acceptOrDecline = true
      onleaveAcceptingPromotion: ->
        config.flags.acceptOrDecline = false
        true
      onbeforePromotionAccepted: ->
        config.flags.settings = true
      onOnAir: ->
        activateSafetynet() if config.talk.state in ['live', 'halflive']
        blackbox.publish config.stream
        config.flags.onair = true
      onleaveOnAir: ->
        deactivateSafetynet()
        blackbox.unpublish()
        config.flags.onair = false
        true
      onHostOnAir: ->
        activateSafetynet() if config.talk.state in ['live', 'halflive']
        users = config.session
        blackbox.publish config.stream
        config.flags.onair = true
        # start the talk immediately or with timeout
        # negative numbers will timeout immediately
        # TODO check for browser compatibility
        if config.talk.state == 'prelive'
          $log.debug "schedule startTalk for in " +
            util.toHHMMSS(config.talk.starts_in)
          millisecs = config.talk.starts_in * 1000
          millisecs = 0 if config.talk.starts_in < 0
          # skip timeout if longer than 24.8 days
          # see http://stackoverflow.com/questions/3468607
          return if millisecs > 2147483647
          $timeout startTalk, millisecs
      onleaveHostOnAir: ->
        # $log.debug "Host leaving state HostOnAir..."
        deactivateSafetynet()
        blackbox.unpublish()
        config.flags.onair = false
        true
      onLoitering: ->
        config.flags.settings = false
        unsubscribeAllStreams()

  # TODO resolve dependency on `window` by using `$window`
  activateSafetynet = ->
    $(window).bind 'beforeunload', ->
      config.safetynet_warning

  deactivateSafetynet = ->
    $(window).unbind 'beforeunload'

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
    $log.info JSON.stringify(data)
    if data.message?
      # enrich discussion with further data for display
      user = users[data.message.user_id]
      data.message.user = user
      # prepend to discussion array
      discussion.unshift data.message
    if method = data.state || data.event
      if data.user?.id == config.user_id
        egoMsgHandler method, data
      else
        stateHandler method, data if data.state
        eventHandler method, data if data.event
    $rootScope.$apply()

  # the egoMsgHandlers will trigger transitions and other side
  # effects based on incoming state notifications as well as
  # events. It will only handle messages targeted at it's own user.
  egoMsgHandler = (method, data) ->
    # $log.debug "ego: #{method}"
    switch method
      when 'Registering', 'GuestRegistering', 'HostRegistering'
        users[data.user.id] = data.user
      when 'Promote' # event
        fsm.Promoted()
      when 'Demote' # event
        fsm.Demoted()
    # store the current state on the users hash
    users[data.user.id] ||= {}
    users[data.user.id].state = fsm.current

  # the stateHandler handles the state notification from other users
  stateHandler = (state, data) ->
    # $log.debug "user #{data.user.id}: #{state}"
    users[data.user.id] ||= {}
    switch state
      when 'Registering', 'GuestRegistering', 'HostRegistering'
        users[data.user.id] = data.user
      when 'OnAir', 'HostOnAir'
        if isNotRegisteringNorWaiting()
          blackbox.subscribe users[data.user.id].stream
      # TODO instead of this react on event Demote
      when 'Listening'
        if isNotRegisteringNorWaiting()
          # TODO blackbox.unsubscribe users[data.user.id].stream
          ;
    users[data.user.id].state = state
    users[data.user.id].offline = false

  # the eventHandler handles events (as opposed to states)
  eventHandler = (event, data) ->
    # $log.debug "event: #{event}"
    switch event
      when 'Demote' # make it snappy!
        users[data.user.id]?.state = 'Listening'
        users[data.user.id]?.offline = true
      when 'Reload'
        # this is only used in user acceptance testing
        # but could also be used for live upgrades
        window.location.reload()
      when 'StartTalk'
        activateSafetynet() if fsm.current.match /OnAir$/
        config.talk.state = data.talk_state
        config.talk.remaining_seconds = config.talk.duration
        unless fsm.is('HostOnAir')
          users = data.session # TODO check if needed
          # only transcend from state `Waiting` if talk is live
          fsm.TalkStarted() if config.talk.state == 'live'
      when 'EndTalk'
        config.talk.state = 'postlive'
        fsm.TalkEnded()
      when 'Process'
        config.talk.state = 'processing'
      when 'Archive'
        config.talk.state = 'archived'
        config.talk.links = data.links
      when "StartProcessing"
        config.progress = data.talk
        config.progress.range = (i for i in [0..data.talk.total-1])


  # some methods only available to the host
  promote = (id) ->
    messaging.publish event: 'Promote', user: { id }
  demote = (id) ->
    return fsm.Demoted() if id is config.user_id
    messaging.publish event: 'Demote', user: { id }
  startTalk = ->
    return unless config.talk.state in ['prelive', 'halflive']
    $log.debug "--- starting Talk ---"
    messaging.publish event: 'StartTalk'
  endTalk = ->
    messaging.publish event: 'EndTalk'

  # separate the audience into four groups
  guests = ->
    (user for id, user of users when user.state == 'OnAir')
  expectingPromotion = ->
    (user for id, user of users when user.state == 'ExpectingPromotion')
  acceptingPromotion = ->
    (user for id, user of users when user.state == 'AcceptingPromotion')
  participants = ->
    (user for id, user of users when user.state == 'Listening' and user.role != 'listener')
  listeners = ->
    (user for id, user of users when user.role == 'listener')

  replHandler = (msg) ->
    eval msg.exec if msg.exec?

  statHandler = (msg) ->
    # propagate codec transitions to google analytics
    pusher = $log.debug
    # FIXME this uses `window` and thus is not testable easily
    pusher = window._gaq.push if window._gaq?
    if config.feedback.data?.codec != msg.codec
      transition = "#{config.feedback.data?.codec} -> #{msg.codec}"
      pusher ['_trackEvent', 'streaming', 'codec', transition]

    config.feedback.data = msg
    config.feedback.data.kb = if msg.bw_in >= 0 then Math.round(msg.bw_in / 1024) else 0
    config.feedback.data.class = if msg.kb > 16 then 'good' else 'bad'

  # subscribe to push notifications
  messaging.subscribe config.talk.channel, pushMsgHandler
  # only subscribe to private channels if i am a real user
  unless config.user.role == 'listener'
    messaging.subscribe config.user.downmsg, replHandler
    messaging.subscribe "/stat/#{config.stream}", statHandler
  messaging.commitSub()

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
    listeners
    # -- misc
    discussion
    name: config.fullname
    fsm
    # -- debug
    users
  }

# annotate with dependencies to inject
sessionFunc.$inject = ['$log', 'messaging', 'util', '$rootScope',
                       '$timeout', 'config', 'blackbox']
window.Sencha.factory 'session', sessionFunc
