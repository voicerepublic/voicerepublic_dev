'use strict'

describe 'upstream-spec', ->

	beforeEach window.module 'sencha'

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
			expect(config).toEqual jasmine.any Object
			expect(upstream).toEqual jasmine.any Object

			expect(upstream.message).toEqual jasmine.any Function

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
