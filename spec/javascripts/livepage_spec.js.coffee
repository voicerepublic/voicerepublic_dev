describe 'Sencha App', ->

  beforeEach module('Sencha')

  describe 'Livepage Controller', ->
    it 'should be a success', inject ($controller) ->
      scope = {}
      ctrl = $controller 'Livepage',
        $scope: scope
      expect(scope.countdown).toBe 'computing...'

      # talk started an hour ago and ends in a second
      ## now = Math.round((new Date).getTime() / 1000)
      ## scope.config.starts_at = now - 360
      ## scope.config.ends_at = now + 1
      ## expect(scope.calculateCountdown(now)).toBe 1
      ## expect(scope.calculateCountdown(now-361)).toBe 1

  describe 'Util Service', ->
    it 'should have utils', inject (util) ->
      expect(util).toBeDefined()

    it 'should provide a function toHHMMSS', inject (util) ->
      expect(util.toHHMMSS).toBeDefined()
      expect(util.toHHMMSS).toEqual(jasmine.any(Function))

      expect(util.toHHMMSS('123')).toEqual('00:02:03')
