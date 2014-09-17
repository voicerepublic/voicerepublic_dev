
uploadFunc = function($scope, FileUploader) {

  $scope.addingFailed = false;

  var uploader = $scope.uploader = new FileUploader({
    url: window.talk_upload_url,
    method: 'POST',
    formData: [{ 'key': window.talk_uuid }],
    queueLimit: 1,
    autoUpload: true
  });

  uploader.filters.push({
    name: 'fileFilter',
    fn: function(item /*{File|FileLikeObject}*/, options) {
      var type = '|' + item.type.slice(item.type.lastIndexOf('/') + 1) + '|';
      return '|ogg|wav|mp3|m4a|'.indexOf(type) !== -1;
    }
  });

  uploader.onWhenAddingFileFailed = function(item /*{File|FileLikeObject}*/, filter, options) {
    $scope.addingFailed = true;
  };
  uploader.onAfterAddingFile = function(fileItem) {
    // TODO: Add uuid to hidden field
    // TODO: Lock form to not be submitted
    $scope.addingFailed = false;
  };
  uploader.onErrorItem = function(fileItem, response, status, headers) {
    console.info('onErrorItem', fileItem, response, status, headers);
  };
  uploader.onCompleteAll = function() {
    console.info('onCompleteAll');
  };
}

uploadFunc.$inject = ['$scope', 'FileUploader'];

window.Sencha.controller('UploadCtrl', uploadFunc);
