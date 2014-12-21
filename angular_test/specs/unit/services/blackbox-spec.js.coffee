'use strict'

beforeEach window.module 'Sencha'

describe 'blackbox-spec', ->
	$log = undefined
	$window = undefined
	$timeout = undefined
	config = undefined
	blackbox = undefined

	beforeEach window.inject (_$log_, _$window_, _$timeout_, _config_, _blackbox_) ->
		$log = _$log_
		$window = _$window_
		$timeout = _$timeout_
		config = _config_
		blackbox = _blackbox_

	it 'blackbox and config should be defined', ->
		expect(blackbox).toBeDefined()
		expect(config).toBeDefined()
		expect(blackbox).toEqual jasmine.any Object
		expect(config).toEqual jasmine.any Object

	it 'logging should be available on init', ->
		expect($log.debug.logs).toContain ['Initializing BlackboxService...']
		expect($log.error.logs[0][0]).toMatch /Error embedding SWF on #/

	it 'check initial state of info', ->
		expect(blackbox.info).toBeDefined()
		expect(blackbox.info).toEqual jasmine.any Object 
		expect(blackbox.info.lastEvent).toEqual 'none'

	describe 'Under test: flash methods bound to $window', ->

		it 'check the flashCallback functionality', ->
			expect($window.flashCallback).toBeDefined()
			expect($window.flashCallback).toEqual jasmine.any Function

			successLog = ['BlackboxService initialized.']
			expect($log.debug.logs).not.toContain successLog
			expect(config.flags.blackboxReady).toBeFalsy() 

			$window.flashCallback()

			expect($log.debug.logs).toContain successLog

			expect(config.flags.blackboxReady).toBeTruthy()

		it 'check the flashLog logging functionality', ->
			msg = 'lorep ipsum blackbox'

			expect($window.flashLog).toBeDefined()
			expect($window.flashLog).toEqual jasmine.any Function

			$window.flashLog msg

			expect($log.debug.logs).toContain [msg]

		it 'check the flashErrorHandler functionality with code: NetConnection.Connect.Closed', ->
			code = 'NetConnection.Connect.Closed'
			stream = 'foo'
			expectedInfoLog = "Flash: #{code} on stream #{stream} in state #{config.talk.state} at"

			#spyOn(blackbox, 'subscribe').and.callThrough()

			expect($window.flashErrorHandler).toBeDefined()
			expect($window.flashErrorHandler).toEqual jasmine.any Function

			$window.flashErrorHandler code, stream

			expect($log.info.logs[0][0]).toMatch expectedInfoLog
			expect(blackbox.info.lastEvent).toEqual code

			#expect(blackbox.subscribe).toHaveBeenCalledWith stream 
			expect($log.debug.logs).toContain ["subscriptions: #{stream}"]

		it 'check the flashErrorHandler functionality with code: NetConnection.Connect.Failed', ->
			code = 'NetConnection.Connect.Failed'
			stream = 'foo'
			expectedInfoLog = "Flash: #{code} on stream #{stream} in state #{config.talk.state} at"

			$window.flashErrorHandler code, stream

			expect($log.info.logs[0][0]).toMatch expectedInfoLog
			expect(blackbox.info.lastEvent).toEqual 'reconnecting'

			# for not explicit testing use: 
			#expect( -> $timeout.verifyNoPendingTasks()).toThrowError()
			# else
			expect( -> $timeout.verifyNoPendingTasks()).toThrowError 'Deferred tasks to flush (1): {id: 0, time: 1000}'

			#method reconnect/subscribe shouldn't be called before flush of timeout
			expect($log.debug.logs).not.toContain ["subscriptions: #{stream}"]

			#flush the pending task
			$timeout.flush()

			#verify there is no task pending after flush
			expect( -> $timeout.verifyNoPendingTasks()).not.toThrowError()

			#unfortunately jasmine spies dont work well with angular, therefore we test reconnect/subscibing implicitly
			expect($log.debug.logs).toContain ["subscriptions: #{stream}"]

		it 'check the functionality of flashFeedback', ->
			expect($window.flashFeedback).toBeDefined()
			expect($window.flashFeedback).toEqual jasmine.any Function

			#noop return value of function

		it 'check the settingsClosed functionality', ->
			expect($window.settingsClosed).toBeDefined()
			expect($window.settingsClosed).toEqual jasmine.any Function

			expect(config.flags.settings).toBeTruthy()

			$window.settingsClosed()

			expect(config.flags.settings).toBeFalsy()

	describe 'Under async test: public methods of blackbox service', ->

		it 'check the publish functionality', (done) ->
			name = 'foo'

			expect(blackbox.publish).toBeDefined()
			expect(blackbox.publish).toEqual jasmine.any Function

			blackbox.publish name

			done()

			###
			setTimeout ( -> 
				window.dump $log.debug.logs
				done()), 3000
			###

			#cannot access the deferred object to test async'ly

		it 'check the unpublish functionality', (done) ->
			expect(blackbox.unpublish).toBeDefined()
			expect(blackbox.unpublish).toEqual jasmine.any Function
			
			#$window.flashCallback()
			blackbox.unpublish()
			done()
			
			###
			Somehow the promise wont get fulfilled from api

			setTimeout ( -> 
				expect($log.debug.logs).toContain ['unpublishing...']
				done()), 1000
			###

		it 'check the subscribe functionality', (done) ->
			name = 'foo'

			expect(blackbox.subscribe).toBeDefined()
			expect(blackbox.subscribe).toEqual jasmine.any Function

			blackbox.subscribe name

			expect($log.debug.logs).toContain ["subscriptions: #{name}"]

			done()

		it 'check the subscribe functionality for an already subscribed name', (done)->
			name = 'foo'

			blackbox.subscribe name
			blackbox.subscribe name

			expect($log.debug.logs).toContain ["already subscribed to #{name}"] 

			done()

		it 'check the micCheck functionality', ->
			expect(blackbox.micCheck).toBeDefined()
			expect(blackbox.micCheck).toEqual jasmine.any Function

			# no access to test api 

		it 'check the mute functionality', ->
			expect(blackbox.mute).toBeDefined()
			expect(blackbox.mute).toEqual jasmine.any Function

			# no access to test api 

		it 'check the unmute functionality', ->
			expect(blackbox.unmute).toBeDefined()
			expect(blackbox.unmute).toEqual jasmine.any Function

			# no access to test api 

		it 'check the setStreamingServer functionality', ->
			expect(blackbox.setStreamingServer).toBeDefined()
			expect(blackbox.setStreamingServer).toEqual jasmine.any Function

			# no access to test api 

		it 'check the setVolume functionality', ->
			expect(blackbox.setVolume).toBeDefined()
			expect(blackbox.setVolume).toEqual jasmine.any Function

			expect($).toBeDefined()

			#jQ = $(".icon-volume-mute")

			#spyOn jQ, 'toggle'

			blackbox.setVolume 42

			#expect(jQ.toggle).toHaveBeenCalled() 

			# no access to test api 
		


		  
		  
		  
	  
		  
		  
		  

		  
			




		  



			
			


		  
		  
	  
