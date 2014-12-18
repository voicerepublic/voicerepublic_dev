'use strict'

describe 'upstream-spec', ->

	beforeEach window.module 'Sencha'

	describe 'upstreamFunc', ->
		$httpBackend = undefined
		config = undefined
		upstream = undefined

		beforeEach window.inject (_$httpBackend_, _config_, _upstream_) ->
		  	$httpBackend = _$httpBackend_
		  	config = _config_
		  	upstream = _upstream_

		afterEach ->
			$httpBackend.verifyNoOutstandingExpectation()
			$httpBackend.verifyNoOutstandingRequest()

		it 'upstream and mock-config should be defined', ->
			expect(config).toBeDefined()
			expect(upstream).toBeDefined()

		it 'check the upstream put functionality', ->
			msg = 
				text: 'text'
				state: 'live'
				event: 'started'

			$httpBackend.expectPUT("/xhr/talk/#{config.talk_id}", { msg }).respond 200, ''
			upstream.put msg
			$httpBackend.flush()

		it 'check the upstream put functionality for an undefined msg', ->
			msg = undefined

			$httpBackend.expectPUT("/xhr/talk/#{config.talk_id}", { msg: { } }).respond 304, ''
			upstream.put msg
			$httpBackend.flush()

		it 'check the upstream message functionality', ->
			content =
				id: 1
				title: 'Karma rocks'
				message: 'Lorem ipsum dolor sit amet'

			anotherContent = 1337

			$httpBackend.expectPOST("/xhr/talk/#{config.talk_id}/messages", { content }).respond 201, ''
			upstream.message content
			$httpBackend.flush()

			$httpBackend.expectPOST("/xhr/talk/#{config.talk_id}/messages", { content: anotherContent }).respond 201, ''
			upstream.message anotherContent
			$httpBackend.flush()

		it 'check the upstream message functionality for an undefined content', ->
			content = undefined

			# shouldn't be expected to send data: content: { } ?
			$httpBackend.expectPOST("/xhr/talk/#{config.talk_id}/messages", { }).respond 304, ''
			upstream.message content
			$httpBackend.flush()

		it 'check the upstream event functionality', ->
			name = 'starting'
			msg = 
				text: 'Starting Talk'
				state: 'half-live'

			$httpBackend.expectPUT("/xhr/talk/#{config.talk_id}", { msg }).respond 304, ''
			upstream.event name, msg
			$httpBackend.flush()

			expect(msg.event).toMatch name

		it 'check the upstream event functionality for an undefined msg', ->
			name = 'starting'
			msg = undefined

			$httpBackend.expectPUT("/xhr/talk/#{config.talk_id}", { msg: { event: name } }).respond 304, ''
			upstream.event name, msg
			$httpBackend.flush()

			expect(msg).toBeUndefined()

		it 'check the upstream state functionality', ->
			name = 'ListeningButReady'
			msg = 
				text: 'foo'
				event: 'listening'

			$httpBackend.expectPUT("/xhr/talk/#{config.talk_id}", { msg }).respond 304, ''
			upstream.state name, msg
			$httpBackend.flush()

			expect(msg.state).toMatch name

		it 'check the upstream event functionality for an undefined msg', ->
			name = 'ListeningButReady'
			msg = undefined

			$httpBackend.expectPUT("/xhr/talk/#{config.talk_id}", { msg: { state: name } }).respond 304, ''
			upstream.state name, msg
			$httpBackend.flush()

			expect(msg).toBeUndefined()
		  


		  

		  
		  

		  

	  

