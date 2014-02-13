# The LivepageController
Livepage.controller 'Livepage', ($scope, $log, config, session, blackbox) ->

  $scope.config   = config
  $scope.session  = session
  $scope.blackbox = blackbox

  $scope.talkIsPrelive = ->
    config.talk.state == 'prelive'

  $scope.talkIsLive = ->
    config.talk.state == 'live'

  $scope.talkIsPostlive = ->
    config.talk.state == 'postlive'

  $scope.showStartTalk = ->
    session.fsm.is('Hosting') and
      config.talk.state == 'prelive'

  $scope.showEndTalk = ->
    session.fsm.is('Hosting') and
      config.talk.state == 'live'

  
