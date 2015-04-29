# The LivepageController
livepageFunc = ($scope, $log, $interval, config, session, blackbox, util, $window, upstream) ->

  # private

  hasFlash = ->
    swfobject.getFlashPlayerVersion().major > 0

  # public

  $scope.setNellyReload = (b) ->
    config.flags.nellyReload = b

  $scope.nellyAlert = ->
    config.feedback.data.codec == 'Nellymoser8'

  $scope.progress = ->
    percentage = 100 / config.progress.total * config.progress.index + 1
    "width: #{Math.floor(percentage)}%"

  $scope.showFlashError = ->
    !hasFlash() and (config.talk.state in ['halflive', 'live'])

  $scope.showStartButton = ->
    session.fsm.is('HostOnAir') and config.talk.state == 'halflive'

  $scope.showUnstartedMessage = ->
    !session.fsm.is('HostOnAir') and config.talk.state == 'halflive'

  $scope.showEndTalk = ->
    session.fsm.is('HostOnAir') and config.talk.state == 'live'

  $scope.showDownloadButton = ->
    config.talk.state == 'archived'

  $scope.showInfoLink = ->
    config.talk.state in ['halflive','live']

  $scope.showTalkTeaser = ->
    config.talk.state in ['prelive','postlive','processing','archived']

  $scope.showCountdown = ->
    config.talk.state == 'prelive'

  $scope.trouble = ->
    return 'reconnecting' if blackbox.info.lastEvent == 'reconnecting'
    return 'trouble connecting' if config.flags.connecting
    false

  $scope.showBandwidth = ->
    session.fsm.is("HostOnAir") and config.talk.state in ['prelive','halflive','live']

  $scope.showParticipantActionsBox = ->
    config.talk.state in ['prelive','halflive','live']

  $scope.showPrelive = ->
    (session.fsm.is('HostOnAir') or session.fsm.is('OnAir')) and
      config.talk.state == 'prelive'

  $scope.showOnAir = ->
    config.flags.onair and config.talk.state in ['live','halflive']

  $scope.muteState = false
  $scope.toggleMicMute = ->
    $scope.muteState = !$scope.muteState
    if $scope.muteState
      blackbox.mute()
    else
      blackbox.unmute()

  $scope.feedback = config.feedback

  $scope.showAcceptOrDecline = ->
    session.fsm.is("AcceptingPromotion")

  $scope.showAwaitingMic = ->
    session.fsm.is("ExpectingPromotion")

  descriptionCollapsed = true

  $scope.descriptionCollapsable = ->
    $(".talks-show .description-innerheight").outerHeight() > 180

  $scope.descriptionCollapsed = ->
    $scope.descriptionCollapsable() && descriptionCollapsed

  $scope.toggleDescription = ->
    descriptionCollapsed = !descriptionCollapsed


  # unconsolidated

  sendMessage = ->
    upstream.message $scope.message.content
    $scope.message.content = ''

  $scope.message = { content: '' }

  $scope.startTalk = session.startTalk
  $scope.endTalk = session.endTalk

  # returns list of users expecting promotion
  $scope.expectingPromotion = session.expectingPromotion

  # returns list of users accepting promotion
  $scope.acceptingPromotion = session.acceptingPromotion

  # takes user id
  $scope.promote = session.promote
  $scope.demote = session.demote

  $scope.numberOfListeners = ->
    config.talk.listeners

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

  $scope.talkIsQueued = ->
    config.talk.state in ['pending', 'postlive']

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
  $scope.cancelMicRequest = -> session.fsm.MicRequestCanceled()

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
    $scope.countdown = "#{util.toHHMMSS(sec)} #{config.t.minutes}"
    days = sec / (60*60*24)
    $scope.countdown = "#{Math.floor(days)} #{config.t.days}" if days > 2
    percent = Math.min(100, 100 - (100 / config.talk.duration) * sec)
    $scope.talkProgress = percent

  $interval updateCountdown, 1000

  # DO NOT USE THESE IN THE VIEW!
  # THESE ARE HERE FOR DEBUGGING ONLY
  # I MEAN IT!
  $scope.config = config
  $scope.session = session

livepageFunc.$inject = ['$scope', '$log', '$interval', 'config',
  'session', 'blackbox', 'util', '$window', 'upstream']
window.Sencha.controller 'Livepage', livepageFunc
