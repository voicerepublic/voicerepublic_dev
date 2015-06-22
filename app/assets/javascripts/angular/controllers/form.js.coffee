formFunc = ($scope, $log, validity) ->
  $scope.valid = validity.valid

formFunc.$inject = [ "$scope", "$log", "validity" ]
window.sencha.controller "FormController", formFunc
