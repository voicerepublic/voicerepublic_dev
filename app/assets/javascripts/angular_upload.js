//= require angular
//= require angular-file-upload

//inject angular file upload directives and service.
uploadApp = angular.module('Upload', ['angularFileUpload']);

// Use Rails CSRF Protection
uploadApp.config(function($httpProvider) {
  var authToken;
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  return $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
});


var UploadCtrl = [ '$scope', '$upload', function($scope, $upload) {
  $scope.talkForm = { $invalid: true }
  $scope.saveTalk = function(e) {
    window.alert("foo");
    console.log("triggers the saveTalk() function!");
    // do not submit form through regular means
    return false;
  };

  $scope.onFileSelect = function($files) {

    //$files: an array of files selected, each file has name, size, and type.
    for (var i = 0; i < $files.length; i++) {
      var file = $files[i];
      $scope.upload = $upload.upload({
        url: '/xhr/upload_talks',
        //method: 'POST' or 'PUT',
        //headers: {'header-key': 'header-value'},
        //withCredentials: true,
        data: {'talk[title]': "yes", 'talk[uuid]': window.talk_uuid },
        file: file, // or list of files ($files) for html5 only
        //fileName: 'doc.jpg' or ['1.jpg', '2.jpg', ...] // to modify the name of the file(s)
        // customize file formData name ('Content-Disposition'), server side file variable name.
        //fileFormDataName: myFile, //or a list of names for multiple files (html5). Default is 'file'
        // customize how data is added to formData. See #40#issuecomment-28612000 for sample code
        //formDataAppender: function(formData, key, val){}
      }).progress(function(evt) {
        debugger
        progress = parseInt(100.0 * evt.loaded / evt.total);
        window.alert("progress: " + progress);

        console.log('percent: ' + progress);
      }).success(function(data, status, headers, config) {
        // file is uploaded successfully
        if(status==200) {
          console.log("All done!");
          $('.progress .meter').width('100%');
          $('.progress .meter').html("100%");
        }
        console.log(data);
      });
      //.error(...)
      //.then(success, error, progress);
      // access or attach event listeners to the underlying XMLHttpRequest.
      //.xhr(function(xhr){xhr.upload.addEventListener(...)})
    }
    /* alternative way of uploading, send the file binary with the file's content-type.
       Could be used to upload files to CouchDB, imgur, etc... html5 FileReader is needed.
       It could also be used to monitor the progress of a normal http post/put request with large data*/
    // $scope.upload = $upload.http({...})  see 88#issuecomment-31366487 for sample code.
  };
}];
