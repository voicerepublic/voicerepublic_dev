# The LivepageController
Livepage.controller 'Livepage', ($scope, $log, $interval,
                                 config, session, blackbox) ->

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

  # countdown logic
  $scope.countdown = 'computing...'

  setCountdown = ->
    s = config.starts_at
    t = Math.round(new Date().getTime() / 1000)
    diffInSeconds = s - t
    c = (new Date).clearTime().
        addSeconds(Math.abs(diffInSeconds)).
        toString('H:mm:ss')
    c = "-#{c}" if diffInSeconds < 0 
    $scope.countdown = c

  $interval setCountdown, 1000
  
