#= require swfobject
#= require angular
#= require state-machine.min
#= require_self
#= require_tree ./angular

window.Livepage = angular.module 'Livepage', []

window.Livepage.factory "$exceptionHandler", ($log) ->
  (exception, cause) ->
    exception.message += " (caused by \"" + cause + "\")"
    throw exception
