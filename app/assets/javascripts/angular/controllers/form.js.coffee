formFunc = ($scope, $log, validity, safetynet) ->
  $scope.valid = validity.valid
  $scope.deactivateSafetynet = safetynet.deactivate

formFunc.$inject = [ "$scope", "$log", "validity", "safetynet" ]
window.sencha.controller "FormController", formFunc
