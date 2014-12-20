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
			
			


		  
		  
	  
