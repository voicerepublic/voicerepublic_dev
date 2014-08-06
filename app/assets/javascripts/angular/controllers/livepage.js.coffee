# The LivepageController
livepageFunc = ($scope, $log, $interval, config, session, blackbox, util, $window) ->

  # private

  hasFlash = ->
    swfobject.getFlashPlayerVersion().major > 0

  # public

  $scope.showFlashError = ->
    !hasFlash() and (config.talk.state in ['halflive', 'live'])

  $scope.showStartButton = ->
    config.talk.state == 'halflive'

  $scope.showEndTalk = ->
    session.fsm.is('HostOnAir') and config.talk.state == 'live'

  $scope.showDownloadButton = ->
    config.talk.state == 'archived'

  $scope.showCountdown = ->
    config.talk.state == 'prelive'

  $scope.showSituation = ->
    config.talk.state == 'halflive'

  $scope.trouble = ->
    return 'reconnecting' if blackbox.info.lastEvent == 'reconnecting'
    return 'trouble connecting' if config.flags.connecting
    false

  # unconsolidated

  sendMessage = ->
    session.upstream.message $scope.message.content
    $scope.message.content = ''

  $scope.message = { content: '' }

  $scope.startTalk = session.startTalk
  $scope.endTalk = session.endTalk
  $scope.expectingPromotion = session.expectingPromotion
  $scope.acceptingPromotion = session.acceptingPromotion
  $scope.promote = session.promote
  $scope.demote = session.demote
  $scope.listeners = session.listeners
  $scope.mediaLinks = config.talk.links
  $scope.discussion = session.discussion

  $scope.toggleShowSettings = ->
    config.flags.settings = !config.flags.settings

  $scope.showSettings = ->
    config.flags.settings

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
    unless $("a[href=#discussion]").parent().hasClass('active')
      $("a[href=#discussion] .icon-bubble-multi").click()
    sendMessage() if e.which == 13 # Enter

  $scope.talkIsPrelive = ->
    config.talk.state == 'prelive'

  $scope.talkIsHalflive = ->
    config.talk.state == 'halflive'

  $scope.talkIsLive = ->
    config.talk.state == 'live'

  $scope.talkIsPostlive = ->
    config.talk.state == 'postlive'

  $scope.talkIsProcessing = ->
    config.talk.state == 'processing'

  $scope.talkIsArchived = ->
    config.talk.state == 'archived'

  $scope.showEndTalk = ->
    session.fsm.is('HostOnAir') and
      config.talk.state == 'live'

  # Speex codec was introduced in Flash version 10. Before, there was only
  # Nellymoser. Flash 10 has been released 2008 already, Flash 11 was released
  # 2011. Flash 11.2 is the latest version to be supported on Linux.
  # Debian Wheezy ships Flash version 11.2 already. We should not support
  # Media Platforms older than Debian Stable and we should not require
  # a version that is not accessible on Linux.
  $scope.hasFlash = ->
    v = swfobject.getFlashPlayerVersion()
    (v.major > 11) || ((v.major == 11) && (v.minor == 2))

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
  'session', 'blackbox', 'util', '$window']
Livepage.controller 'Livepage', livepageFunc

