# see doc/messages.md for some documentation
#
upstreamFunc = (config, $http, $log) ->

  put = (msg) ->
    msg ||= {}
    #$log.debug 'Sending...'
    #$log.debug msg
    $http.put "/xhr/talk/#{config.talk_id}", { msg }

  message = (content) ->
    $http.post "/xhr/talk/#{config.talk_id}/messages", { content }

  event = (name, msg) ->
    msg ||= {}
    msg.event = name
    put msg

  state = (name, msg) ->
    msg ||= {}
    msg.state = name
    put msg

  { # expose
    put # low level
    message
    event
    state
  }

upstreamFunc.$inject = ['config', '$http', '$log']
window.Sencha.factory 'upstream', upstreamFunc
