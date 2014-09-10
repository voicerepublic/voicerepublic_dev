#= require angular
#= require angular-file-upload
#= require ./angular/controllers/upload

# inject angular file upload directives and service.
uploadApp = angular.module('Upload', ['angularFileUpload'])

configFunc = ($logProvider) ->
  $logProvider.debugEnabled window.debug or window.insider

configFunc.$inject = ['$logProvider']

# Use Rails CSRF Protection
uploadApp.config ($httpProvider) ->
  authToken = undefined
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
