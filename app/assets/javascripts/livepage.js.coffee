#= require swfobject
#= require angular
#= require state-machine.min
#= require_self
#= require_tree ./angular

window.Livepage = angular.module 'Livepage', []


# Override Angular exception handler to receive a backtrace in Angular
# exceptions
exceptionFunc = ($log) ->
  (exception, cause) ->
    exception.message += " (caused by \"" + cause + "\")"
    throw exception

exceptionFunc.$inject = ['$log']
window.Livepage.factory "$exceptionHandler", exceptionFunc
