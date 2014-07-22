#= require swfobject
#= require angular
#= require state-machine.min
#= require_self
#= require_tree ./angular

window.Livepage = angular.module 'Livepage', []

configFunc = ($logProvider) ->
  $logProvider.debugEnabled window.debug or window.insider

configFunc.$inject = ['$logProvider']
window.Livepage.config configFunc




