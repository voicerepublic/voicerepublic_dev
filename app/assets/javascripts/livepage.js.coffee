#= require jquery
#= require swfobject
#= require private_pub
#= require angular
#= require foundation.min
#= require state-machine.min


# --------------------------------------------------------------------------------
# create an angular module
window.Livepage = angular.module 'Livepage', []


# --------------------------------------------------------------------------------
# This factory is a BlackboxService-factory.
#
# The angularstyle dependencies are
#
#  * $log    - angular's logging service
#  * $window - angular's wrapper around the browser's window object
#  * $q      - angular's promise/deferred implementation
#
# Besides that it relies on swfobject to load the flash component.
# 
Livepage.factory 'BlackboxService', ($log, $window, $q) ->

  # this will initialize the flash async, so we'll start with a deferred
  # which will let us return a promise, which will be fullfilled async'ly
  deferred = $q.defer()

  # flash can only access methods in the window scope
  # at least we can use $window for testability
  $window.flashCallback = ->
    try
      # still uses 'navigator' to retireve the user agent string
      # and 'document' to lookup the flash object (is there another way?)
      # FIXME this is really bad for testability
      isInternetExplorer = navigator.appName.indexOf("Microsoft") != -1
      blackbox = document.all.Blackbox if isInternetExplorer
      blackbox ||= document.Blackbox

      deferred.resolve blackbox
      $log.debug 'BlackboxService initialized.'
    catch error
      $log.error error
  
  $window.flashLog = (msg) ->
    $log.debug msg

  $window.flashFeedback = (value) ->
    $log.debug "Feedback: #{value}"

  # in Rails provided by Venue#details_for(user)
  # TODO this is mainly a reminiscence and can be tidied up
  flashVars =
    # "v#{id}-e#{next_event.id}-u#{user.id}"
    streamId: "blablub"
    # "/story/v#{id}e#{next_event.id}"
    channel: ""
    # 'host' or 'participant'
    role: 'host'
    # PrivatePub subscriptions
    storySubscription: null
    backSubscription: null
    chatSubstcription: null
    # rtmp url
    # streamer: "rtmp://kluuu.com/offrecord"
    streamer: "rtmp://0.0.0.0/record"
    # callback after flash initialize complete
    afterInitialize: 'flashCallback',
    logMethod: 'flashLog',
    feedbackMethod: 'flashFeedback'
      
  params = {}
  attributes = { id: "Blackbox", name: "Blackbox" }
  version = "10.3.181.22"

  $log.debug 'Initializing BlackboxService...'
  margin = 0

  swfobject.embedSWF "Blackbox.swf", "flashContent",
    215 + margin, 140 + margin,
    version, null, flashVars, params, attributes

  # public methods which exposed
  publish = (name) ->
    deferred.promise.then (api) ->
      api.publish name

  unpublish = ->
    deferred.promise.then (api) ->
      $log.debug 'unpublishing...'
      api.unpublish()

  subscribe = (name) ->
    if name == undefined
      return alert "VollpfostenError: Subscribing to no one?" 
    deferred.promise.then (api) ->
      api.subscribe name

  soundcheck = ->
    deferred.promise.then (api) ->
      api.micCheck()

  mute = ->
    deferred.promise.then (api) ->
      api.mute()
  
  unmute = ->
    deferred.promise.then (api) ->
      api.unmute()

  setStreamingServer = (url) ->
    deferred.promise.then (api) ->
      api.setStreamingServer(url)
      
  # expose public methods
  {
    publish
    unpublish
    subscribe
    soundcheck
    mute
    unmute
    setStreamingServer
  }


# --------------------------------------------------------------------------------
# For now the UpstreamService directly publishes to Faye,
# but eventually this will have to become ajax calls.
Livepage.factory 'UpstreamService', (ConfigService, PrivatePubService, $log) ->

  config = ConfigService

  publish = (data) ->
    PrivatePubService.publish "/#{config.namespace}/public", data

  register = (data) ->
    temp = { users: {} }
    temp.users[data.name] = {
      name: data.name
      role: 'participant'
      image: "http://lorempixel.com/80/80/people/#{Math.round(Math.random()*9)+2}/"
    }
    publish temp

  update = (name, attrs) ->
    temp = { users: {} }
    temp.users[name] = attrs
    publish temp

  # expose
  {
    register
    update
  }


# --------------------------------------------------------------------------------
# The SessionService is the single source for insession
# data and contains the session logic.
#
# CHECK Maybe it makes sense to split this further into
#  * stuff that belongs to the user 
#  * stuff that belongs to the whole session (all users)
Livepage.factory 'SessionService', ($log, PrivatePubService, UtilService, $rootScope,
                                    UpstreamService, ConfigService, BlackboxService) ->

  config   = ConfigService
  util     = UtilService
  upstream = UpstreamService
  blackbox = BlackboxService

  name = "noname#{Math.round(Math.random()*1000)}"

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

  PrivatePubService.subscribe "/#{config.namespace}/public", dataHandler
  PrivatePubService.subscribe "/#{config.namespace}/private/#{name}", dataHandler

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


# --------------------------------------------------------------------------------
# The UtilService is just a container for utility functions.
Livepage.factory "UtilService", ->

  merge = (target, src) ->
    array = Array.isArray src
    dst = array && [] || {}
    if array
      target ||= []
      dst = dst.concat target
      src.forEach (e, i) ->
        if typeof target[i] == 'undefined'
          dst[i] = e
        else if typeof e == 'object'
          dst[i] = merge(target[i], e)
        else
          if target.indexOf(e) == -1
            dst.push(e)
    else
      if target && typeof target == 'object'
        Object.keys(target).forEach (key) ->
          dst[key] = target[key]
      Object.keys(src).forEach (key) ->
        if typeof src[key] != 'object' || !src[key]
          dst[key] = src[key]
        else
          if !target[key]
            dst[key] = src[key]
          else
            dst[key] = merge(target[key], src[key])
    dst

  # expose
  { merge }


# --------------------------------------------------------------------------------
# Since angular's dependency injection decides in what order to
# resolve dependencies this could totally go into the html page
# rendered by rails.
Livepage.factory "ConfigService", ->
  {
    fayeClientUrl: 'http://kluuu.com:9293/faye/client.js'
    fayeUrl: 'http://kluuu.com:9293/faye'
    timestamp: 1302306682972
    signature: '123'
    namespace: 'talk123'
  }


# --------------------------------------------------------------------------------
# This will load the faye client library, instanciate the client,
# set up an extension for use with PrivatePub and expose an API
# to put calls to the client on a promise chain, to queue these until
# the client is set up.
Livepage.factory "PrivatePubService", ($log, $q, ConfigService) ->

  config = ConfigService
  client = null

  deferred = $q.defer()
  promise = deferred.promise

  fayeExtension =
    outgoing: (message, callback) ->
      if message.channel == "/meta/subscribe"
        message.ext ||= {}
        message.ext.private_pub_signature = config.signature
        message.ext.private_pub_timestamp = config.timestamp
      callback message

  $log.debug 'Loading Faye client...'
  $.getScript config.fayeClientUrl, (x) ->
    $log.debug 'Faye client loaded. Instanciating Faye client...'
    client = new Faye.Client(config.fayeUrl)
    client.addExtension(fayeExtension)
    deferred.resolve true
    $log.debug 'Instanciated Faye client.'

  # public methods
  subscribe = (channel, callback) ->
    success = ->
      $log.debug "Subscribing to Faye channel #{channel}..."
      client.subscribe(channel, callback)
    $log.debug "Push subscribing to Faye channel '#{channel}' onto promise chain."
    # queue the call onto the promise chain
    promise = promise.then success

  # NOTE this will not and is not supposed to work with PrivatePub
  publish = (channel, data) ->
    $log.debug "Push publishing to Faye channel '#{channel}' onto promise chain."
    promise = promise.then ->
      client.publish channel, data
                                
  {
    subscribe
    publish
  }


# --------------------------------------------------------------------------------
# The meta controller is only for testing.
# It is only allowed to manipulate the SessionService.
# It will not be available in the actual application.
Livepage.controller 'MetaCtrl', ($scope, SessionService, BlackboxService, $log, ConfigService) ->

  config = ConfigService
  $scope.session = SessionService
  $scope.blackbox = BlackboxService

  $scope.servers = [
    'rtmp://kluuu.com/recordings',
    'rtmp://localhost/record',
  ]
  $scope.server = $scope.servers[0]
  $scope.roles = [ 'Host', 'Guest', 'Listener' ]
  $scope.users = [ $scope.session.name ]

  $scope.$watch 'server', (newVal, oldVal, scope) ->
    BlackboxService.setStreamingServer newVal

  # $scope.$watch 'session.name', (newVal, oldVal, scope) ->
  #   $scope.users = (user for user in $scope.users when user != oldVal)
  #   $scope.users.push newVal

  $scope.init = ->
    session.fsm.Initialized()


# --------------------------------------------------------------------------------
# The LivepageController
Livepage.controller 'LivepageCtrl', ($scope, SessionService, BlackboxService) ->

  $scope.session = SessionService
  $scope.blackbox = BlackboxService


# --------------------------------------------------------------------------------
# Initialze Foundation
$(document).foundation()
