Livepage.factory 'upstream', (config, privatePub, $log, $http) ->

  put = (type, data) ->
    event = data
    event.command = type
    $http.put "/api/talk/#{config.talk_id}", { event }

  { put }
