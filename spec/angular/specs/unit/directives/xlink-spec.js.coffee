'use strict'

beforeEach window.module 'Sencha'

describe 'xlink-spec', ->
	$compile = undefined
	$rootScope = undefined

	beforeEach window.inject (_$compile_, _$rootScope_) ->
		$compile = _$compile_
		$rootScope = _$rootScope_

	it 'check the ngXlinkHref directive with value', ->
		scope = $rootScope

		scope.link = '/example.html'

		element = $compile('<a ngXlinkHref="{{link}}">link</a>')(scope)

		scope.link = '/example2.html'

		scope.$digest()

		expect(scope.$eval 'link').toEqual element.attr 'ngXlinkHref'

		# something is wrong... the directive is not doing 'attrs.$set attrName, value' though 'attrs.$observe' invokes it

	it 'check the ngXlinkHref directive without value', ->
		scope = $rootScope

		element = $compile('<a ngXlinkHref="{{link}}">link</a>')(scope)

		scope.$digest()

		expect(scope.$eval 'link').toBeUndefined()
		expect(element.attr 'ngXlinkHref').toEqual '' 
	  