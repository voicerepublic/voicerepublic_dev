'use strict'

beforeEach window.module 'sencha'

describe 'nag_users-spec', ->
  $controller = undefined
  $scope = undefined
  NagUsersCtrl = undefined

  beforeEach window.inject (_$controller_, _session_) ->
    $controller = _$controller_

  beforeEach ->
    window.current_user =
      id: 0
      is_anonymous: true
    $scope = {}
    NagUsersCtrl = $controller 'NagUsersController', {$scope: $scope}

  it 'knows whether the user is an anonyous user', ->
    expect($scope.isAnonymousUser(current_user)).toBe(true)

  it 'knows whether a user is newly on the platform', ->
    expect($scope.hasNotSeenModalAlready(current_user)).toBe(true)
