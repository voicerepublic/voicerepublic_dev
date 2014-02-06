Livepage.factory 'upstream', (config, privatePub, $log, $http) ->

  put = (event, data) ->
    data.event = event
    $http.put "/api/talk/#{config.talk_id}", data

  { put }
