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
    session.fsm.is('HostOnAir') and
      config.talk.state == 'prelive'

  $scope.showEndTalk = ->
    session.fsm.is('HostOnAir') and
      config.talk.state == 'live'

  $scope.numberOfListeners = session.numberOfListeners

  # show/hide-flags
  $scope.flags = config.flags

  # trigger
  $scope.requestMic = -> session.fsm.MicRequested()

  $scope.acceptPromotion = ->
    session.fsm.PromotionAccepted()

  $scope.declinePromotion = ->
    session.fsm.PromotionDeclined()
                        
  # the countdown is the number of seconds
  #   * until the start of the talk before the talk
  #   * until the end of the talk during the talk
  #   * an empty string after the talk
  $scope.countdown = 'computing...'

  calculateCountdown = (now) ->
    end = config.ends_at
    return '' if now > end
    start = config.starts_at
    return end - now if now > start
    start - now

  setCountdown = ->
    now = Math.round(new Date().getTime() / 1000)
    sec = calculateCountdown(now)
    # foundation's datepicker depends on `date.js`
    # so we'll use `date.js` here, despite `moment.js`
    # is known to be a much better alternative
    date = (new Date).clearTime().addSeconds(sec)
    formatted = date.toString('H:mm:ss')
    $scope.countdown = formatted

  $interval setCountdown, 1000
  
  # expose to test
  # TODO maybe move into util
  $scope.calculateCountdown = calculateCountdown

