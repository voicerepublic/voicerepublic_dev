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
blackboxFunc = ($log, $window, $q) ->

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

  swfobject.embedSWF "/flash/Blackbox.swf", "flashContent",
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
  }

# annotate with dependencies to inject
blackboxFunc.$inject = ['$log', '$window', '$q']
Livepage.factory 'blackbox', blackboxFunc
