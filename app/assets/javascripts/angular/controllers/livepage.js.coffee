# The LivepageController
livepageFunc = ($scope, $log, $interval, config, session, blackbox, util) ->

  sendMessage = ->
    session.upstream.message $scope.message.content
    $scope.message.content = ''

  # $scope.config   = config
  # $scope.session  = session
  # $scope.blackbox = blackbox

  $scope.message = { content: '' }

  $scope.endTalk = session.endTalk
  $scope.expectingPromotion = session.expectingPromotion
  $scope.acceptingPromotion = session.acceptingPromotion
  $scope.promote = session.promote
  $scope.demote = session.demote
  $scope.participants = session.participants
  $scope.listeners = session.listeners
  $scope.mediaLinks = config.talk.links
  $scope.discussion = session.discussion

  $scope.setVolume = blackbox.setVolume
  $scope.mute = blackbox.mute
  $scope.unmute = blackbox.unmute

  $scope.showHostActions = ->
    config.user.role == 'host' and
      config.talk.state == 'live'

  $scope.userIsAListener = ->
    config.user.role == 'listener'

  $scope.guests = ->
    return session.guests() if config.talk.state == 'live'
    config.guests

  $scope.messageKeyup = (e) ->
    sendMessage() if e.which == 13 # Enter

  $scope.talkIsPrelive = ->
    config.talk.state == 'prelive'

  $scope.talkIsLive = ->
    config.talk.state == 'live'

  $scope.talkIsPostlive = ->
    config.talk.state == 'postlive'

  $scope.talkIsArchived = ->
    config.talk.state == 'archived'

  $scope.showEndTalk = ->
    session.fsm.is('HostOnAir') and
      config.talk.state == 'live'

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
  $scope.talkProgress = 0

  calculateCountdown = (now) ->
    end = config.ends_at
    start = config.starts_at
    switch config.talk.state
      when 'prelive' then start - now
      when 'live' then end - now
      else ''

  setCountdown = ->
    now = Math.round(new Date().getTime() / 1000)
    sec = calculateCountdown(now)
    $scope.countdownInSeconds = sec
    $scope.countdown = util.toHHMMSS(sec)
    percent = Math.max(100, 100 - (100 / config.talk.duration) * sec)
    $scope.talkProgress = percent

  $interval setCountdown, 1000
  
  # expose to test
  # TODO maybe move into util
  $scope.calculateCountdown = calculateCountdown

livepageFunc.$inject = ['$scope', '$log', '$interval', 'config',
  'session', 'blackbox', 'util']
Livepage.controller 'Livepage', livepageFunc

