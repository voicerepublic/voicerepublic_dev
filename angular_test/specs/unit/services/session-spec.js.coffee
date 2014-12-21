'use strict'

beforeEach window.module 'Sencha'

describe 'session-spec', ->
	$log = undefined
	$timeout = undefined
	$rootScope = undefined
	$httpBackend = undefined
	config = undefined
	upstream = undefined
	blackbox = undefined
	session = undefined

	beforeEach window.inject (_$log_, _$timeout_, _$rootScope_, _$httpBackend_, _config_, _upstream_, _blackbox_, _session_) ->
		$log = _$log_
		$timeout = _$timeout_
		$rootScope = _$rootScope_
		$httpBackend = _$httpBackend_
		config = _config_
		upstream = _upstream_
		blackbox = _blackbox_
		session = _session_

	it 'session, blackbox, upstream & config should be defined', ->
		expect(session).toBeDefined()
		expect(blackbox).toBeDefined()
		expect(upstream).toBeDefined()
		expect(config).toBeDefined()

		expect(session).toEqual jasmine.any Object
		expect(blackbox).toEqual jasmine.any Object
		expect(upstream).toEqual jasmine.any Object
		expect(config).toEqual jasmine.any Object

	describe '- Under test: initialized defaults -', ->

		it 'should initialize config properly', ->
			flags = 
				onair: false
				reqmic: false
				acceptOrDecline: false
				settings: false
				connecting: true
				blackboxReady: false

			feedback =
				data: { bw_in: 0 }

			expect(config.flags).toBeDefined()
			expect(config.flags).toEqual flags

			expect(config.feedback).toEqual feedback

		it 'should initialize users properly', ->
			users = config.session

			expect(session.users).toEqual users

		it 'should initialize discussion properly', ->
			discussion = config.discussion

			expect(session.discussion).toEqual discussion

		it 'should initialize name properly', ->
			expect(session.name).toEqual config.fullname

	describe '- Under test: session events -', ->

		it 'check the promote event functionality', ->
			id = 1

			spyOn upstream, 'event'

			session.promote id

			expect(upstream.event).toHaveBeenCalledWith 'Promote', user: { id }

		it 'check the demote event for common functionality', ->
			id = 1

			spyOn upstream, 'event'

			session.demote id

			expect(upstream.event).toHaveBeenCalledWith 'Demote', user: { id }

		it 'check the demote event functionality incase user_id equals currentUser in config', ->
			id = config.user_id

			expect(session.fsm).toBeDefined()

			spyOn session.fsm, 'Demoted'
			spyOn upstream, 'event'

			session.demote id

			expect(session.fsm.Demoted).toHaveBeenCalled() 
			expect(upstream.event).not.toHaveBeenCalled()

		it 'check the startTalk event for common functionality', ->
			spyOn upstream, 'event'

			session.startTalk()

			expect(upstream.event).toHaveBeenCalledWith 'StartTalk'
			expect($log.debug.logs).toContain ['--- starting Talk ---']

		it 'check the startTalk event functionality incase config.talk.state is not prelive or halflife', ->
			config.talk.state = 'life'

			spyOn upstream, 'event'

			session.startTalk()

			expect(upstream.event).not.toHaveBeenCalled()
			expect($log.debug.logs).not.toContain ['--- starting Talk ---']

		it 'check the endTalk event functionality', ->
			spyOn upstream, 'event'

			session.endTalk()

			expect(upstream.event).toHaveBeenCalledWith 'EndTalk'

	describe '- Under test: session groups -', ->

		it 'check the guests functionality', ->
			guests = config.session['1337']

			expect(session.guests()[0]).toEqual guests

		it 'check the expectingPromotion functionality', ->
			expectingPromotion = config.session['42']

			expect(session.expectingPromotion()[0]).toEqual expectingPromotion

		it 'check the acceptingPromotion functionality', ->
			acceptingPromotion = config.session['7']

			expect(session.acceptingPromotion()[0]).toEqual acceptingPromotion

		it 'check the participants functionality', ->
			participants = config.session['2']

			expect(session.participants()[0]).toEqual participants

		it 'check the listeners functionality', ->
			listeners = config.session['3']

			expect(session.listeners()[0]).toEqual listeners

	describe '- Under test: session fsm -', ->
		fsm = undefined

		beforeEach ->
		  fsm = session.fsm

		it 'statemachine fsm should be defined', ->
			expect(fsm).toBeDefined()
			expect(fsm).toEqual jasmine.any Object

		it 'check the error functionality of the statemachine', ->
			eventName = 'Demote'
			from = 'OnAir'
			to = 'ListeningButReady'
			args = 'foo'
			errorCode = 123
			errorMessage = 'Demote failed'

			fsm.error eventName, from, to, args, errorCode, errorMessage

			expect($log.debug.logs).toContain [[eventName, from, to, args, errorCode]]
			expect($log.debug.logs).toContain [errorMessage]

		it 'check the onenterstate functionality of the statemachine when subscription not done', ->
			event = 'Demote'
			from = 'OnAir'
			to = 'ListeningButReady'

			spyOn upstream, 'state'

			fsm.onenterstate event, from, to

			# verify because subscriptionDone is false
			expect(upstream.state).not.toHaveBeenCalled()

			# verify this call is registered in the deferred tasks queue
			expect( -> $timeout.verifyNoPendingTasks()).toThrowError()

			$timeout.flush()

			# verify because subscriptionDone is still false
			expect(upstream.state).not.toHaveBeenCalled()

			#verify the call is registered again
			expect( -> $timeout.verifyNoPendingTasks()).toThrowError()

			#there is no access to privatePub nor the property subscriptionDone to test the common case



		  
		    
		  
	  
		  
		  
		  
		  
		  
	  
		  
		  
		  
		  
	