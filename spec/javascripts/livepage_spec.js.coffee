describe 'Livepage App', ->
  beforeEach module('Livepage')

  describe 'Livepage Controller', ->
    it 'should be a success', inject ($controller) ->
      scope = {}
      ctrl = $controller 'Livepage',
        $scope: scope
      expect(scope.countdown).toBe 0
