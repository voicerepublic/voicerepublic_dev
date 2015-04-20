upstreamFunc = (config, $http, $log) ->

  message = (content) ->
    $http.post "/xhr/talk/#{config.talk_id}/messages", { content }

  { # expose
    message
  }

upstreamFunc.$inject = ['config', '$http', '$log']
window.Sencha.factory 'upstream', upstreamFunc
