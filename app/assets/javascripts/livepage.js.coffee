#= require swfobject
#= require angular
#= require state-machine.min
#= require_self
#= require_tree ./angular

window.Livepage = angular.module 'Livepage', []

configFunc = ($logProvider) ->
  # see app/assets/javascripts/components/persisted_log.js
  # for modifications to `console.log`
  $logProvider.debugEnabled true

configFunc.$inject = ['$logProvider']
window.Livepage.config configFunc




