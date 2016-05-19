safetynetFunc = ($window) ->

  activate = (warning) ->
    $($window).bind "beforeunload", ->
      warning

  deactivate = ->
    $($window).unbind 'beforeunload'

  {
    activate
    deactivate
  }

safetynetFunc.$inject = ["$window"]
window.sencha.factory "safetynet", safetynetFunc
