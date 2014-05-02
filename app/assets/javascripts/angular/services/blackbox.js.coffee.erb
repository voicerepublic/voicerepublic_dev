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
blackboxFunc = ($log, $window, $q, config) ->

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

  $window.flashErrorHandler = (code, stream) ->
    # switch code
    #   when 'NetConnection.Connect.Failed'
    #     if pubStream == stream
    #       $log.info "TODO #{code} #{stream}"
    #   when 'NetConnection.Connect.Closed'
    #     if pubStream == stream
    #       publish stream
    #   when 'NetConnection.Connect.NetworkChange'
    #     $log.info "TODO #{code} #{stream}"

    # throwing will track errors in errbit
    status = code
    throw "Flash Error: #{code} on stream #{stream}"

  $window.flashFeedback = (value) ->
    $log.debug "Feedback: #{value}"

  flashVars =
    # this will later be set by `setStreamingServer`
    streamer: "rtmp://0.0.0.0/record"
    # callback after flash initialize complete
    afterInitialize: 'flashCallback'
    logMethod: 'flashLog'
    errorMethod: 'flashErrorHandler'
    feedbackMethod: 'flashFeedback'
      
  params = {}
  attributes = { id: "Blackbox", name: "Blackbox" }
  version = "10.3.181.22"

  subscriptions = []

  $log.debug 'Initializing BlackboxService...'
  margin = 0

  callback = (obj) ->
    return $log.debug "Embed SWF on ##{obj.id}" if obj.success
    $log.error "Error embedding SWF on ##{obj.id}"

  swfobject.embedSWF config.blackbox_path, "flashContent",
    215 + margin, 140 + margin,
    version, null, flashVars, params, attributes, callback

  pubStream = null
  status = 'ok'

  # public methods which exposed
  publish = (name) ->
    pubStream = name
    deferred.promise.then (api) ->
      api.publish name

  unpublish = ->
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

  soundcheck = ->
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
    deferred.promise.then (api) ->
      api.setVolume(vol)
      
  # expose public methods
  {
    publish
    unpublish
    subscribe
    soundcheck
    mute
    unmute
    setStreamingServer
    setVolume
    status
  }

# annotate with dependencies to inject
blackboxFunc.$inject = ['$log', '$window', '$q', 'config']
Livepage.factory 'blackbox', blackboxFunc
