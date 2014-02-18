# see doc/messages.md for some documentation
# 
Livepage.factory 'upstream', (config, $http, $log) ->

  put = (msg) ->
    msg ||= {}
    #$log.debug 'Sending...'
    #$log.debug msg
    $http.put "/api/talk/#{config.talk_id}", { msg }

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
    event
    state
  }
