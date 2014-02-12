describe 'Livepage App', ->

  beforeEach module('Livepage')

  describe 'Livepage Controller', ->
    it 'should be a success', inject ($controller) ->
      scope = {}
      ctrl = $controller 'Livepage',
        $scope: scope
      expect(scope.countdown).toBe 'computing...'
      
      # talk started an hour ago and ends in a second
      now = Math.round((new Date).getTime() / 1000)
      scope.config.starts_at = now - 360
      scope.config.ends_at = now + 1
      expect(scope.calculateCountdown(now)).toBe 1
      expect(scope.calculateCountdown(now-361)).toBe 1
