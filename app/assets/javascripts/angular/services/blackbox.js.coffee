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
blackboxFunc = ($log, $window, $q, config, $timeout) ->

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

  # determine if it is a good state to reconnect
  reconnectMode = ->
    config.talk.state == 'live' or
      config.talk.state == 'prelive'

  subscriptions = []
  pubStream = null
  info = { lastEvent: 'none' }

  reconnect = (stream) ->
    # check if the closed stream was the published stream
    if pubStream == stream
      publish stream
    else
      # remove stream from list of subscribed streams
      subscriptions = subscriptions.filter (s) -> s isnt stream
      subscribe stream

  $window.flashErrorHandler = (code, stream) ->
    info.lastEvent = code
    state = config.talk.state
    $log.info "Flash: #{code} on stream #{stream} in state #{state} at #{new Date}"

    if reconnectMode()
      switch code
        when 'NetConnection.Connect.Closed'
          reconnect stream
        when 'NetConnection.Connect.Failed'
          info.lastEvent = 'reconnecting'
          $timeout (-> reconnect(stream)), 1000
        # when 'NetConnection.Connect.NetworkChange'
        #   $log.info "TODO #{code} #{stream}"

  $window.flashFeedback = (value) ->
    #$log.debug "Feedback: #{value}"
    ((x)->)(value) # noop

  $window.settingsClosed = ->
    config.flags.settings = false

  flashVars = $.extend config.blackbox,
    # this will later be set by `setStreamingServer`
    streamer: "rtmp://0.0.0.0/record"
    # callback after flash initialize complete
    afterInitialize: 'flashCallback'
    logMethod: 'flashLog'
    errorMethod: 'flashErrorHandler'
    feedbackMethod: 'flashFeedback'
    settingsClosed: 'settingsClosed'
    closeMethod: 'settingsClosed' # FIXME misnomer

  params =
    wmode: 'transparent'
  attributes =
    id: "Blackbox"
    name: "Blackbox"
    allowScriptAccess: 'sameDomain'
  version = "10.3.181.22"

  $log.debug 'Initializing BlackboxService...'

  callback = (obj) ->
    return $log.debug "Embed SWF on ##{obj.id}" if obj.success
    $log.error "Error embedding SWF on ##{obj.id}"

  swfobject.embedSWF config.blackbox_path, "flashContent",
    '100%', '100%',
    version, null, flashVars, params, attributes, callback

  # public methods which exposed
  publish = (name) ->
    pubStream = name
    deferred.promise.then (api) ->
      api.publish name

  unpublish = ->
    pubStream = null
    deferred.promise.then (api) ->
      $log.debug 'unpublishing...'
      api.unpublish()

  subscribe = (name) ->
    if name == undefined
      return alert "VollpfostenError: Subscribing to no one?"
    if name in subscriptions
      $log.debug "already subscribed to #{name}"
      return
    subscriptions.push name
    $log.debug "subscriptions: " + subscriptions.join(', ')
    deferred.promise.then (api) ->
      api.subscribe name

  micCheck = ->
    deferred.promise.then (api) ->
      api.micCheck()

  mute = ->
    deferred.promise.then (api) ->
      api.muteMic()

  unmute = ->
    deferred.promise.then (api) ->
      api.unmuteMic()

  setStreamingServer = (url) ->
    deferred.promise.then (api) ->
      api.setStreamingServer(url)

  setVolume = (vol) ->
    # FIXME: This is jQuery. Rewrite with Angular.
    $(".icon-volume-mute").toggle()
    $(".icon-volume-mute2").toggle()

    deferred.promise.then (api) ->
      api.setVolume(vol)

  # expose public methods
  {
    publish
    unpublish
    subscribe
    micCheck
    mute
    unmute
    setStreamingServer
    setVolume
    info
  }

# annotate with dependencies to inject
blackboxFunc.$inject = ['$log', '$window', '$q', 'config', '$timeout']
window.Sencha.factory 'blackbox', blackboxFunc
