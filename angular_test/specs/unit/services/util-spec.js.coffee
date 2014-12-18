'use strict'

describe 'util-spec', ->

  beforeEach window.module 'Sencha'

  describe '- toHHMMSS -', ->

    it 'check the existence of toHHMMSS function', window.inject (util) ->
      expect(util.toHHMMSS).toBeDefined()

    it 'tests the common functionality of toHHMMSS', window.inject (util) ->
      timeString = 22 + ':' + 22 + ':' + 22
      expect(util.toHHMMSS 80542).toEqual timeString  

    it 'tests against special value 0', window.inject (util) ->
      timeString = '00'+ ':' + '00' + ':' + '00'
      expect(util.toHHMMSS 0).toEqual timeString

  describe '- merge -', ->

    it 'check the existence of the merge function', window.inject (util) ->
      expect(util.merge).toBeDefined()

    it 'check the common functionality of the merge function for arrays', window.inject (util) ->
      target = ['foo', 'bar']
      source = ['rab', 'oof']
      merged = ['foo', 'bar', 'rab', 'oof']
      expect(util.merge target, source).toEqual merged

    it 'check the functionality of the merge function for equal arrays', window.inject (util) ->
      target = ['foo', 'bar']
      source = ['foo', 'bar']
      expect(util.merge target, source).toEqual source
      expect(util.merge source, target).toEqual source

    it 'check the functionality of the merge function for empty arrays', window.inject (util) ->
      target = []
      source = ['rab', 'oof']
      expect(util.merge target, source).toEqual source
      expect(util.merge source, target).toEqual source
      expect(util.merge target, target).toEqual target

    it 'check the common functionality of the merge function for objects', window.inject (util) ->
      target = 
        foo: 'bar'
        oof: 'rab'
      source = 
        bar: 'foo'
        rab: 'oof'
      merged = 
        foo: 'bar'
        oof: 'rab'
        bar: 'foo'
        rab: 'oof'
      expect(util.merge target, source).toEqual merged

    it 'check the functionality of the merge function for empty objects', window.inject (util) ->
      target = {}
      source = 
        bar: 'foo'
        rab: 'oof'
      expect(util.merge target, source).toEqual source
      expect(util.merge source, target).toEqual source
      expect(util.merge target, target).toEqual target

    it 'check the functionality of the merge function for equal objects', window.inject (util) ->
      target = 
        foo: 'foo'
        bar: 'bar'
      source = 
        foo: 'foo'
        bar: 'bar'
      expect(util.merge target, source).toEqual source
      expect(util.merge source, target).toEqual source