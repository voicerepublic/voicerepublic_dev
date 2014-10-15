#= require swfobject
#= require angular
#= require angularjs-file-upload
#= require state-machine.min
#= require_self
#= require_tree ./angular

# inject angular file upload directives and service.
window.Sencha = angular.module 'Sencha', ['angularFileUpload']

configFunc = ($logProvider) ->
  $logProvider.debugEnabled window.debug or window.insider

configFunc.$inject = ['$logProvider']
window.Sencha.config configFunc

# Use Rails CSRF Protection
# Alternative solution is to overwrite verified_request? in the controller that
# is to be accessed (like in xhr/talks_controller)
configFunc = ($httpProvider) ->
  authToken = undefined
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

configFunc.$inject = ['$httpProvider']
window.Sencha.config configFunc
