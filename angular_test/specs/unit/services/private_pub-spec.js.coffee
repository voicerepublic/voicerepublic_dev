'use strict'

beforeEach window.module 'Sencha'

describe 'private_pub-spec', ->
	$log = undefined
	config = undefined
	privatePub = undefined

	beforeEach window.inject (_$log_, _config_, _privatePub_) ->
		$log = _$log_
		config = _config_
		privatePub = _privatePub_

	it 'privatePub and mock-config should be defined', ->
		expect(config).toBeDefined()
		expect(privatePub).toBeDefined()
		expect(config).toEqual jasmine.any Object
		expect(privatePub).toEqual jasmine.any Object

	it 'check debug log', ->
		expect($log.debug.logs).toContain ['Loading Faye client...']

	describe '- Under test: callback -', ->
		callback = undefined

		beforeEach ->
			callback = privatePub.callback

		it 'callback should be defined', ->
			expect(callback).toBeDefined()
			expect(callback).toEqual jasmine.any Function

	describe '- Under test: subscribe -', ->
		subscribe = undefined

		beforeEach ->
			subscribe = privatePub.subscribe

		it 'subscribe should be defined', ->
		  	expect(subscribe).toBeDefined()
		  	expect(subscribe).toEqual jasmine.any Function

		it 'check the subscribe functionality', ->
			channel = config.talk.channel
			handler = jasmine.createSpy 'handler'

			subscribe channel, handler

			expect($log.debug.logs).toContain ["Push subscribing to Faye channel '#{channel}' onto promise chain."]

			# seems like jQuery wont load fayeClient in this configuration, therefore the deferred will never get resolved...
			expect(handler).not.toHaveBeenCalled()

			# debug logs related to the promise chain aren't propagated...
			#window.dump $log.debug.logs 
		  
		  
			
	  
