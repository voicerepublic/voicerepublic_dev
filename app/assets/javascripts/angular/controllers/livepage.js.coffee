# The LivepageController
livepageFunc = ($scope, $log, $interval, config, session, blackbox) ->

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

  $scope.userIsAListener = ->
    config.user.role == 'listener'

  $scope.guests = ->
    switch config.talk.state
      when 'live'
        session.guests()
      else
        (user for id, user of session.users when user.role == 'guest')

  $scope.messageKeyup = (e) ->
    sendMessage() if e.keyIdentifier == "Enter"

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

  calculateCountdown = (now) ->
    end = config.ends_at
    start = config.starts_at
    switch config.talk.state
      when 'prelive' then start - now
      when 'live' then end - now
      else ''

  toHHMMSS = (str) ->
    sec_num = parseInt(str, 10)
    hours   = Math.floor(sec_num / 3600)
    minutes = Math.floor((sec_num - (hours * 3600)) / 60)
    seconds = sec_num - (hours * 3600) - (minutes * 60)
    hours   = "0"+hours   if hours   < 10
    minutes = "0"+minutes if minutes < 10
    seconds = "0"+seconds if seconds < 10
    hours+':'+minutes+':'+seconds

  setCountdown = ->
    now = Math.round(new Date().getTime() / 1000)
    sec = calculateCountdown(now)
    $scope.countdownInSeconds = sec
    $scope.countdown = toHHMMSS(sec)

  $interval setCountdown, 1000
  
  # expose to test
  # TODO maybe move into util
  $scope.calculateCountdown = calculateCountdown

livepageFunc.$inject = ['$scope', '$log', '$interval', 'config', 'session', 'blackbox']
Livepage.controller 'Livepage', livepageFunc

