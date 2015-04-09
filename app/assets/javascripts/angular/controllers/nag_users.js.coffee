nagFunc = ($scope, $log, $timeout) ->

  $scope.isAnonymousUser = (user) ->
    user.is_anonymous

  $scope.isNewOnVR = (user) ->
    !localStorage.getItem(user.id)?


  $scope.nagAnonymous = (user) ->
    # OMG, what is he doing? Yes, he's changing the DOM state..
    $('#nagModal').foundation('reveal','open')
    localStorage.setItem(user.id, true)

  if $scope.isAnonymousUser(current_user) and $scope.isNewOnVR(current_user)
    $timeout($scope.nagAnonymous, 20)
    #$timeout($scope.nagAnonymous, 30000)
  else if $scope.isAnonymousUser(current_user)
    $timeout($scope.nagAnonymous, 600000)

nagFunc.$inject = [
  "$scope"
  "$log"
  "$timeout"
]
window.Sencha.controller "NagUsersCtrl", nagFunc
