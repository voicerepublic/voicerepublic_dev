nagFunc = ($scope, $log, $timeout) ->

  $scope.isAnonymousUser = (user) ->
    user.is_anonymous

  $scope.hasNotSeenModalAlready = (user) ->
    # For when there is no entry in localStorage yet
    return true unless localStorage.getItem('user_id_that_has_been_nagged')?
    localStorage.getItem('user_id_that_has_been_nagged') == '#{user.id}'

  $scope.nagAnonymous = ->
    # OMG, what is he doing? Yes, he's changing the DOM state..
    $('#nagModal').foundation('reveal','open')
    localStorage.setItem('user_id_that_has_been_nagged', 0)

  if $scope.isAnonymousUser(current_user) and $scope.hasNotSeenModalAlready(current_user)
    # 30 seconds
    $timeout($scope.nagAnonymous, 30000)
  else if $scope.isAnonymousUser(current_user)
    # 20 minutes
    $timeout($scope.nagAnonymous, 1200000)

nagFunc.$inject = [
  "$scope"
  "$log"
  "$timeout"
]
window.Sencha.controller "NagUsersCtrl", nagFunc
