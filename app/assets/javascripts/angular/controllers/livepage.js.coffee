# The LivepageController
Livepage.controller 'Livepage', ($log, config, $scope, session, blackbox) ->

  $log.debug config # TODO +++ remove debug output +++

  $scope.session = session
  $scope.blackbox = blackbox
  
  session.fsm.Initialized()
