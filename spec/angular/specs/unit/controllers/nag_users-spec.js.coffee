'use strict'

beforeEach window.module 'Sencha'

describe 'nag_users-spec', ->
  $controller = undefined
  # save repetitions
  $scope = undefined
  NagUsersCtrl = undefined
  current_user =
    id: 0
    is_anonymous: true

  beforeEach window.inject (_$controller_, _session_) ->
    $controller = _$controller_

    #preparation for test purpose (else: undefined)

    beforeEach ->
      $scope = {}
      NagUsersCtrl = $controller 'NagUsersCtrl', {$scope: $scope}

      it 'knows whether the user is an anonyous user', ->
        expect(isAnonymousUser(current_user)).toBe(true)

      it 'knows whether a user is newly on the platform', ->
        expect(isNewOnVr(current_user)).toBe(true)

      it 'shows the nagging modal window', ->
        expect($('#nagModal')).toBeHidden()
        nagAonynymous(current_user)
        expect(isNewOnVr(current_user)).toBe(false)
