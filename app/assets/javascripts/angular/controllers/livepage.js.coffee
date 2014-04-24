# The LivepageController
livepageFunc = ($scope, $log, $interval, config, session, blackbox, util) ->

  sendMessage = ->
    session.upstream.message $scope.message.content
    $scope.message.content = ''

  $scope.message = { content: '' }

  $scope.endTalk = session.endTalk
  $scope.expectingPromotion = session.expectingPromotion
  $scope.acceptingPromotion = session.acceptingPromotion
  $scope.promote = session.promote
  $scope.demote = session.demote
  $scope.listeners = session.listeners
  $scope.mediaLinks = config.talk.links
  $scope.discussion = session.discussion
  $scope.showSettings = config.flags.settings

  $scope.participants = ->
    return session.participants() if config.talk.state == 'live'
    config.participants

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
    # TODO: This is not Angular code and maybe not the best way to go
    unless $("a[href=#talk-tab-discussion]").parent().hasClass('active')
      console.log("clicked")
      $("a[href=#talk-tab-discussion] .icon-bubble-multi").click()
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

  $scope.countdown = 'computing...'
  $scope.talkProgress = 0

  updateCountdown = ->
    sec = config.talk.remaining_seconds - 1
    sec = Math.max sec, 0
    config.talk.remaining_seconds = sec
    $scope.countdown = util.toHHMMSS(sec)
    percent = Math.min(100, 100 - (100 / config.talk.duration) * sec)
    $scope.talkProgress = percent

  $interval updateCountdown, 1000

livepageFunc.$inject = ['$scope', '$log', '$interval', 'config',
  'session', 'blackbox', 'util']
Livepage.controller 'Livepage', livepageFunc

