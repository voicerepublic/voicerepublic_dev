#= require angular
#= require angularjs-file-upload
#= require_self
#= require_tree ./angular

# inject angular file upload directives and service.
window.sencha = angular.module 'sencha', ['angularFileUpload']

configFunc = ($logProvider, $httpProvider, $sceDelegateProvider) ->

  # see app/assets/javascripts/components/persisted_log.js
  # for modifications to `console.log`
  $logProvider.debugEnabled true

  # Use Rails CSRF Protection
  # Alternative solution is to overwrite verified_request? in the controller that
  # is to be accessed (like in xhr/talks_controller)
  authToken = undefined
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

  $sceDelegateProvider.resourceUrlWhitelist(["self", "**"])

configFunc.$inject = ['$logProvider', '$httpProvider', '$sceDelegateProvider']
window.sencha.config configFunc
