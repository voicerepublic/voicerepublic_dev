# This will load the faye client library, instanciate the client,
# set up an extension for use with faye-authentication and expose an API
# to put calls to the client on a promise chain, to queue these until
# the client is set up.
messagingFunc = ($log, $q, config) ->

  client = null

  # init promise chain for subscribing
  deferredSub = $q.defer()
  promiseSub = deferredSub.promise

  # init promise chain for publishing
  deferredPub = $q.defer()
  promisePub = deferredPub.promise

  $log.debug 'Loading Faye client...'
  # TODO get rid of dependency on jquery, for testability
  $.getScript config.fayeClientUrl, (x) ->
    config.flags.connecting = false
    $log.debug 'Faye client loaded. Instanciating Faye client...'
    client = new Faye.Client(config.fayeUrl)
    client.addExtension(new FayeAuthentication(client))
    deferredSub.resolve true
    $log.debug 'Instanciated Faye client.'

  indexPub = 0

  # public methods
  publish = (message) ->
    $log.debug "Push on pub chain: #{JSON.stringify(message)}"
    promisePub = promisePub.then ->
      message.index = indexPub = indexPub + 1
      $log.debug "SENDING #{JSON.stringify(message)}"
      client.publish config.user.upmsg, message

  subscribe = (channel, callback) ->
    $log.debug "Push subscribing to Faye channel '#{channel}' onto promise chain."
    promiseSub = promiseSub.then ->
      $log.debug "Subscribing to Faye channel #{channel}..."
      client.subscribe(channel, callback)

  commitSub = ->
    $log.error 'commitSub!'
    promiseSub = promiseSub.then ->
      $log.debug 'Subscriptions done, allow for publishing...'
      deferredPub.resolve true

  {
    publish
    subscribe
    commitSub
  }

# annotate with dependencies to inject
messagingFunc.$inject = ['$log', '$q', 'config']
window.Sencha.factory "messaging", messagingFunc
