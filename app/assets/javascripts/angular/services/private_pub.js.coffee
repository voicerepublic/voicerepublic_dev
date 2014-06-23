# This will load the faye client library, instanciate the client,
# set up an extension for use with PrivatePub and expose an API
# to put calls to the client on a promise chain, to queue these until
# the client is set up.
privatePubFunc = ($log, $q, config) ->

  client = null

  deferred = $q.defer()
  promise = deferred.promise

  fayeExtension =
    outgoing: (message, callback) ->
      if message.channel == "/meta/subscribe"
        channel = message.subscription
        subscription = config.subscriptions[channel]
        $log.error "no subscription for #{channel}" unless subscription?
        message.ext ||= {}
        message.ext.private_pub_signature = subscription.signature
        message.ext.private_pub_timestamp = subscription.timestamp
      callback message

  $log.debug 'Loading Faye client...'
  # TODO get rid of dependency on jquery, for testability
  $.getScript config.fayeClientUrl, (x) ->
    config.flags.connecting = false
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

  {
    subscribe
  }

# annotate with dependencies to inject
privatePubFunc.$inject = ['$log', '$q', 'config']
Livepage.factory "privatePub", privatePubFunc
