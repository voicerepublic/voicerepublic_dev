nagFunc = ($scope, $log, $timeout) ->

  $scope.nagAnonymous = ->
    # OMG, what is he doing? Changing the DOM state.. what a crappy dude..
    $('#nagModal').foundation('reveal','open')
    # Save to Localstorage

  # IF Anonymous User and not Localstorage
  $timeout($scope.nagAnonymous, 2)
  # ELSE setTimout to 30min

nagFunc.$inject = [
  "$scope"
  "$log"
  "$timeout"
]
window.Sencha.controller "NagUsersCtrl", nagFunc
