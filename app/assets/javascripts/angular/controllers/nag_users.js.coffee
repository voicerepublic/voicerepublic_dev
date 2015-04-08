isAnonymousUser = (user) ->
  user.is_anonymous

isNewOnVR = (user) ->
  !localStorage.getItem(user.id)?

nagFunc = ($scope, $log, $timeout) ->

  $scope.nagAnonymous = (user) ->
    # OMG, what is he doing? Yes, he's changing the DOM state..
    $('#nagModal').foundation('reveal','open')
    localStorage.setItem(user.id, true)

  if isAnonymousUser(current_user) and isNewOnVR(current_user)
    $timeout($scope.nagAnonymous, 20)
    #$timeout($scope.nagAnonymous, 30000)
  else if isAnonymousUser(current_user)
    $timeout($scope.nagAnonymous, 600000)

nagFunc.$inject = [
  "$scope"
  "$log"
  "$timeout"
]
window.Sencha.controller "NagUsersCtrl", nagFunc
