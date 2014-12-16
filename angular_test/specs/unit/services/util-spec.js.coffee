'use strict'
describe 'util', ->

  beforeEach module(Sencha)

  describe '- toHHMMSS -', ->
    timeString = ->
      22 + ':' + 22 + ':' + 22

    it 'check the existence of util factory', inject(($injector) ->
      expect($injector).toBeDefined()
      return
    )

    #it 'tests the functionallity of toHHMMSS', ->
      #expect(util.toHHMMSS 80542).toEqual timeString    
      #return

    return

  return