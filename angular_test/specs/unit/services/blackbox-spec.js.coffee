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

	describe 'Under test: flash methods', ->

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
		  
		  
		  

		  
			




		  



			
			


		  
		  
	  
