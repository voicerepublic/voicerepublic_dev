# see doc/messages.md for some documentation
# 
Livepage.factory 'upstream', (config, $http, $log) ->

  put = (userId, msg) ->
    msg ||= {}
    msg.user ||= {}
    msg.user.id = userId
    #$log.debug 'Sending...'
    #$log.debug msg
    $http.put "/api/talk/#{config.talk_id}", { msg }

  event = (userId, name, msg) ->
    msg ||= {}
    msg.event = name
    put userId, msg

  state = (userId, name, msg) ->
    msg ||= {}
    msg.state = name
    put userId, msg

  { # expose
    put # low level
    event
    state
  }
