# The LivepageController
Livepage.controller 'Livepage', ($log, config, $scope, session, blackbox) ->

  $scope.session = session
  $scope.blackbox = blackbox
  
  session.fsm.Initialized()
