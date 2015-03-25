# This will load the faye client library, instanciate the client,
# set up an extension for use with faye-authentication and expose an API
# to put calls to the client on a promise chain, to queue these until
# the client is set up.
messagingFunc = ($log, $q, config) ->

  client = null

  deferred = $q.defer()
  promise = deferred.promise

  $log.debug 'Loading Faye client...'
  # TODO get rid of dependency on jquery, for testability
  $.getScript config.fayeClientUrl, (x) ->
    config.flags.connecting = false
    $log.debug 'Faye client loaded. Instanciating Faye client...'
    client = new Faye.Client(config.fayeUrl)
    client.addExtension(new FayeAuthentication(client))
    deferred.resolve true
    $log.debug 'Instanciated Faye client.'

  # public methods
  publish = (message) ->
    promise = promise.then ->
      client.publish config.user.upmsg, message

  subscribe = (channel, callback) ->
    success = ->
      $log.debug "Subscribing to Faye channel #{channel}..."
      client.subscribe(channel, callback)
    $log.debug "Push subscribing to Faye channel '#{channel}' onto promise chain."
    # queue the call onto the promise chain
    promise = promise.then success

  callback = (func) ->
    promise = promise.then func

  {
    publish
    subscribe
    callback
  }

# annotate with dependencies to inject
messagingFunc.$inject = ['$log', '$q', 'config']
window.Sencha.factory "messaging", messagingFunc
