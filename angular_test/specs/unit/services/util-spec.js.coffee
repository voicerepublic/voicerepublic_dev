'use strict'

describe 'util', ->

  beforeEach window.module 'Sencha'

  describe '- toHHMMSS -', ->

    it 'check the existence of toHHMMSS function', window.inject (util) ->
      expect(util.toHHMMSS).toBeDefined()
      return

    it 'tests the common functionallity of toHHMMSS', window.inject (util) ->
      timeString = 22 + ':' + 22 + ':' + 22
      expect(util.toHHMMSS 80542).toEqual timeString  
      return

    it 'tests against special value 0', window.inject (util) ->
      timeString = '00'+ ':' + '00' + ':' + '00'
      expect(util.toHHMMSS 0).toEqual timeString
      return

    return

  describe '- merge -', ->

    it 'check the existence of the merge function', window.inject (util) ->
      expect(util.merge).toBeDefined
      return

    it 'check the common functionallity of the merge function for arrays', window.inject (util) ->
      target = ['foo', 'bar']
      source = ['rab', 'oof']
      merged = ['foo', 'bar', 'rab', 'oof']
      expect(util.merge target, source).toEqual merged
      return

    it 'check the functionallity of the merge function for equal arrays', window.inject (util) ->
      target = ['foo', 'bar']
      source = ['foo', 'bar']
      expect(util.merge target, source).toEqual source
      expect(util.merge source, target).toEqual source
      return

    it 'check the functionallity of the merge function for empty arrays', window.inject (util) ->
      target = []
      source = ['rab', 'oof']
      expect(util.merge target, source).toEqual source
      expect(util.merge source, target).toEqual source
      expect(util.merge target, target).toEqual target
      return

    it 'check the common functionallity of the merge function for objects', window.inject (util) ->
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
      return  

    it 'check the functionallity of the merge function for empty objects', window.inject (util) ->
      target = {}
      source = 
        bar: 'foo'
        rab: 'oof'
      expect(util.merge target, source).toEqual source
      expect(util.merge source, target).toEqual source
      expect(util.merge target, target).toEqual target
      return

    it 'check the functionallity of the merge function for equal objects', window.inject (util) ->
      target = 
        foo: 'foo'
        bar: 'bar'
      source = 
        foo: 'foo'
        bar: 'bar'
      expect(util.merge target, source).toEqual source
      expect(util.merge source, target).toEqual source
      return  

    return

  return