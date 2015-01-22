'use strict'

beforeEach window.module 'Sencha'

describe 'livepage-spec', ->
	$controller = undefined
	config = undefined
	session = undefined
	blackbox = undefined
	util = undefined
	# save repetitions
	$scope = undefined
	Livepage = undefined

	beforeEach window.inject (_$controller_, _config_, _session_, _blackbox_, _util_) ->
		$controller = _$controller_
		config = _config_
		session = _session_
		blackbox = _blackbox_
		util = _util_

		#preparation for test purpose (else: undefined)

	beforeEach ->
		$scope = {}
		Livepage = $controller 'Livepage', {$scope: $scope}

	it 'every injected variable should be defined', ->
		expect(config).toBeDefined()
		expect(session).toBeDefined()
		expect(blackbox).toBeDefined()
		expect(util).toBeDefined()

		expect(config).toEqual jasmine.any Object
		expect(session).toEqual jasmine.any Object
		expect(blackbox).toEqual jasmine.any Object
		expect(util).toEqual jasmine.any Object

	it 'Livepage & $scope should be defined', ->
		expect(Livepage).toBeDefined()
		expect(Livepage).toEqual jasmine.any Object 

		expect($scope).toBeDefined()
		expect($scope).toEqual jasmine.any Object 

	describe '- Under test: initialized defaults -', ->

		it '$scope variables should have been set properly', ->
			expect($scope.muteState).toBeFalsy()
			expect($scope.feedback).toEqual config.feedback
			expect($scope.message).toEqual { content: '' }
			expect($scope.startTalk).toEqual session.startTalk
			expect($scope.endTalk).toEqual session.endTalk
			expect($scope.expectingPromotion).toEqual session.expectingPromotion
			expect($scope.acceptingPromotion).toEqual session.acceptingPromotion
			expect($scope.promote).toEqual session.promote
			expect($scope.demote).toEqual session.demote
			expect($scope.listeners).toEqual session.listeners
			expect($scope.mediaLinks).toEqual config.talk.links
			expect($scope.discussion).toEqual session.discussion
			expect($scope.setVolume).toEqual blackbox.setVolume
			expect($scope.flags).toEqual config.flags
			expect($scope.countdown).toEqual 'computing...'
			expect($scope.talkProgress).toEqual 0

	describe '- Under test: public controller methods -', ->

		it 'check the $scope.progress functionality', ->
			config.progress = 77

			val = $scope.progress()

			expect(val).toEqual config.progress

		it 'check the $scope.showFlashError functionality', ->
			#note: seems like hasFlash is going to return false
			config.talk.state = 'live'

			val = $scope.showFlashError()

			expect(val).toBeTruthy()

			config.talk.state = 'prelive'

			val = $scope.showFlashError()

			expect(val).toBeFalsy()

		it 'check the $scope.showStartButton functionality', ->
			config.talk.state = 'halflive'
			session.fsm.current = 'HostOnAir'

			val = $scope.showStartButton()

			expect(val).toBeTruthy()

			config.talk.state = 'prelive'
			session.fsm.current = 'foo'

			val = $scope.showStartButton()

			expect(val).toBeFalsy()

		it 'check the $scope.showUnstartedMessage functionality', ->
			config.talk.state = 'halflive'
			session.fsm.current = 'HostOnAir'

			val = $scope.showUnstartedMessage()

			expect(val).toBeFalsy()

			session.fsm.current = 'foo'

			val = $scope.showUnstartedMessage()

			expect(val).toBeTruthy()

		it 'check the $scope.showEndTalk functionality', ->
			config.talk.state = 'live'
			session.fsm.current = 'HostOnAir'

			val = $scope.showEndTalk()

			expect(val).toBeTruthy()

			session.fsm.current = 'foo'

			val = $scope.showEndTalk()

			expect(val).toBeFalsy()

		it 'check the $scope.showDownloadButton functionality', ->
			config.talk.state = 'archived'

			val = $scope.showDownloadButton()

			expect(val).toBeTruthy()

			config.talk.state = 'live'

			val = $scope.showDownloadButton()

			expect(val).toBeFalsy()

		it 'check the $scope.showInfoLink functionality', ->
			config.talk.state = 'live'

			val = $scope.showInfoLink()

			expect(val).toBeTruthy()

			config.talk.state = 'prelive'

			val = $scope.showInfoLink()

			expect(val).toBeFalsy()

		it 'check the $scope.showTalkTeaser functionality', ->
			config.talk.state = 'processing'

			val = $scope.showTalkTeaser()

			expect(val).toBeTruthy()

			config.talk.state = 'halflive'

			val = $scope.showTalkTeaser()

			expect(val).toBeFalsy()

		it 'check the $scope.showCountdown functionality', ->
			config.talk.state = 'prelive'

			val = $scope.showCountdown()

			expect(val).toBeTruthy()

			config.talk.state = 'halflive'

			val = $scope.showCountdown()

			expect(val).toBeFalsy()

		it 'check the $scope.trouble functionality', ->
			blackbox.info.lastEvent = 'reconnecting'

			val = $scope.trouble()

			expect(val).toEqual 'reconnecting'

			blackbox.info.lastEvent = ''
			config.flags.connecting = true

			val = $scope.trouble()

			expect(val).toEqual 'trouble connecting'

			config.flags.connecting = false

			val = $scope.trouble()

			expect(val).toBeFalsy() 

		it 'check the $scope.showBandwidth functionality', ->
			session.fsm.current = 'HostOnAir'
			config.talk.state = 'halflive'

			val = $scope.showBandwidth()

			expect(val).toBeTruthy() 

			session.fsm.current = 'foo'

			val = $scope.showBandwidth()

			expect(val).toBeFalsy()

		it 'check the $scope.showParticipantActionsBox functionality', ->
			config.talk.state = 'halflive'

			val = $scope.showParticipantActionsBox()

			expect(val).toBeTruthy()

		it 'check the $scope.showPrelive functionality', ->
			config.talk.state = 'prelive'
			session.fsm.current = 'HostOnAir'

			val = $scope.showPrelive()

			expect(val).toBeTruthy()

			session.fsm.current = 'foo'

			val = $scope.showPrelive()

			expect(val).toBeFalsy()

		it 'check the $scope.showOnAir functionality', ->
			config.flags.onair = true
			config.talk.state = 'live'

			val = $scope.showOnAir()

			expect(val).toBeTruthy()

			config.flags.onair = false

			val = $scope.showOnAir()

			expect(val).toBeFalsy()

		it 'check the $scope.toggleMicMute functionality', ->
			spyOn blackbox, 'mute'
			spyOn blackbox, 'unmute'

			$scope.muteState = false

			$scope.toggleMicMute()

			expect($scope.muteState).toBeTruthy()
			expect(blackbox.mute).toHaveBeenCalled()

			$scope.toggleMicMute()

			expect($scope.muteState).toBeFalsy()
			expect(blackbox.unmute).toHaveBeenCalled()

		it 'check the $scope.showAcceptOrDecline functionality', ->
			session.fsm.current = 'AcceptingPromotion'

			val = $scope.showAcceptOrDecline()

			expect(val).toBeTruthy()

			session.fsm.current = 'foo'

			val = $scope.showAcceptOrDecline()

			expect(val).toBeFalsy()

		it 'check the $scope.showAwaitingMic functionality', ->
			session.fsm.current = 'ExpectingPromotion'

			val = $scope.showAwaitingMic()

			expect(val).toBeTruthy()

			session.fsm.current = 'foo'

			val = $scope.showAwaitingMic()

			expect(val).toBeFalsy()

		it 'check the $scope.descriptionCollapsable functionality', ->
			# test with wrapped jQuery inject into angular

		it 'check the $scope.descriptionCollapsed functionality', ->
			# test with wrapped jQuery inject into angular

		it 'check the $scope.toggleDescription functionality', ->
			expect($scope.toggleDescription()).toBeFalsy()
			expect($scope.toggleDescription()).toBeTruthy()

		it 'check the $scope.toggleShowSettings functionality', ->
			config.flags.settings = false

			$scope.toggleShowSettings()

			expect(config.flags.settings).toBeTruthy()

			$scope.toggleShowSettings()

			expect(config.flags.settings).toBeFalsy()

		it 'check the $scope.showSettings functionality', ->
			config.flags.settings = true

			expect($scope.showSettings()).toBeTruthy()

			config.flags.settings = false

			expect($scope.showSettings()).toBeFalsy()

		it 'check the $scope.participants functionality', ->
			spyOn session, 'participants'
			config.talk.state = 'live'

			$scope.participants()

			expect(session.participants).toHaveBeenCalled() 

			config.talk.state = 'archived'

			expect($scope.participants()).toEqual config.participants

		it 'check the $scope.showHostActions functionality', ->
			config.user.role = 'host'
			config.talk.state = 'live'

			expect($scope.showHostActions()).toBeTruthy()

			config.user.role = 'listener'

			expect($scope.showHostActions()).toBeFalsy()

		it 'check the $scope.userIsAListener functionality', ->
			config.user.role = 'listener'

			expect($scope.userIsAListener()).toBeTruthy()

			config.user.role = 'host'

			expect($scope.userIsAListener()).toBeFalsy()

		it 'check the $scope.guests functionality', ->
			spyOn session, 'guests'
			config.talk.state = 'live'

			$scope.guests()

			expect(session.guests).toHaveBeenCalled() 

			config.talk.state = 'archived'

			expect($scope.guests()).toEqual config.guests

		it 'check the $scope.messageKeyup functionality', ->
			#not tesable -> rewrite in angular ;)

		it 'check the $scope.talkIsPrelive functionality', ->
			config.talk.state = 'prelive'

			expect($scope.talkIsPrelive()).toBeTruthy()

			config.talk.state = 'halflive'

			expect($scope.talkIsPrelive()).toBeFalsy()

		it 'check the $scope.talkIsHalflive functionality', ->
			config.talk.state = 'prelive'

			expect($scope.talkIsHalflive()).toBeFalsy()

			config.talk.state = 'halflive'
			
			expect($scope.talkIsHalflive()).toBeTruthy()

		it 'check the $scope.talkIsLive functionality', ->
			config.talk.state = 'prelive'

			expect($scope.talkIsLive()).toBeFalsy()

			config.talk.state = 'live'
			
			expect($scope.talkIsLive()).toBeTruthy()

		it 'check the $scope.talkIsPostlive functionality', ->
			config.talk.state = 'prelive'

			expect($scope.talkIsPostlive()).toBeFalsy()

			config.talk.state = 'postlive'
			
			expect($scope.talkIsPostlive()).toBeTruthy()

		it 'check the $scope.talkIsProcessing functionality', ->
			config.talk.state = 'prelive'

			expect($scope.talkIsProcessing()).toBeFalsy()

			config.talk.state = 'processing'

			expect($scope.talkIsProcessing()).toBeTruthy()

		it 'check the $scope.talkIsArchived functionality', ->
			config.talk.state = 'prelive'

			expect($scope.talkIsArchived()).toBeFalsy()

			config.talk.state = 'archived'

			expect($scope.talkIsArchived()).toBeTruthy()

		it 'check the $scope.showEndTalk functionality', ->
			session.fsm.current = 'HostOnAir'
			config.talk.state = 'live'

			expect($scope.showEndTalk()).toBeTruthy()

		it 'check the $scope.hasFlash functionality', ->
			expect($scope.hasFlash()).toBeFalsy()

	xdescribe '- Under test: trigger controller functions - ', ->
		fsm = undefined

		beforeEach ->
		  fsm = session.fsm

		it 'check the $scope.requestMic functionality', ->
			# there is no function MicRequested on fsm!!!

			spyOn fsm, 'MicRequested'

			$scope.requestMic()

			expect(fsm.MicRequested).toHaveBeenCalled()

		it 'check the $scope.cancelMicRequest functionality', ->
			# there is no function MicRequestCanceled on fsm!!!

			spyOn fsm, 'MicRequestCanceled'

			$scope.cancelMicRequest()

			expect(fsm.MicRequestCanceled).toHaveBeenCalled()

		it 'check the $scope.acceptPromotion functionality', ->
			# there is no function PromotionAccepted on fsm!!!

			spyOn fsm, 'PromotionAccepted'

			$scope.acceptPromotion()

			expect(fsm.PromotionAccepted).toHaveBeenCalled()

		it 'check the $scope.declinePromotion functionality', ->
			# there is no function PromotionDeclined on fsm!!!

			spyOn fsm, 'PromotionDeclined'

			$scope.declinePromotion()

			expect(fsm.PromotionDeclined).toHaveBeenCalled()

	describe '- Under test: updateCountdown -', ->

		it 'check the functionality of the updateCountdown with $interval', window.inject ($interval) ->
			config.talk.remaining_seconds = 1337
			config.talk.duration = 42

			$interval.flush 1000

			percent = Math.min(100, 100 - (100 / config.talk.duration) * config.talk.remaining_seconds)

			expect(config.talk.remaining_seconds).toEqual 1336
			expect($scope.countdown).toEqual util.toHHMMSS(config.talk.remaining_seconds)
			expect($scope.talkProgress).toEqual percent


	    
		    
		  
		  
	    
		  