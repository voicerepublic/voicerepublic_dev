
uploadFunc = function($scope, $upload) {
  $scope.saveTalk = function(e) {
    window.alert("foo");
    console.log("triggers the saveTalk() function!");
    // TODO: do not submit form through regular means
    return false;
  };

  $scope.onFileSelect = function($files) {
    //$files: an array of files selected, each file has name, size, and type.
    for (var i = 0; i < $files.length; i++) {

      var file = $files[i];
      $scope.upload = $upload.upload({
        url: window.talk_upload_url,
        method: 'POST',
        headers: {'key': window.talk_uuid },
        //withCredentials: true,
        data: {'key': window.talk_uuid },
        file: file, // or list of files ($files) for html5 only
        //fileName: 'doc.jpg' or ['1.jpg', '2.jpg', ...] // to modify the name of the file(s)
        // customize file formData name ('Content-Disposition'), server side file variable name.
        //fileFormDataName: myFile, //or a list of names for multiple files (html5). Default is 'file'
        // customize how data is added to formData. See #40#issuecomment-28612000 for sample code
        //formDataAppender: function(formData, key, val){}
      }).progress(function(evt) {
        // TODO: Progress is not yet provided by S3 Upload
        progress = parseInt(100.0 * evt.loaded / evt.total);
        window.alert("progress: " + progress);
        console.log('percent: ' + progress);
      }).success(function(data, status, headers, config) {
        // file is uploaded successfully
        console.log("All done!");
        $('.progress .meter').width('100%');
        $('.progress .meter').html("100%");
      });
      //.error(...)
      //.then(success, error, progress);
      // access or attach event listeners to the underlying XMLHttpRequest.
      //.xhr(function(xhr){xhr.upload.addEventListener(...)})



      // ALTERNATIVE way of uploading. This way we might get a trackable
      // progress.
      // See: https://github.com/danialfarid/angular-file-upload/issues/88#issuecomment-31366487

      //var fileReader = new FileReader();
      ////fileReader.readAsArrayBuffer(file);
      //fileReader.readAsDataURL( file )
      //fileReader.onload = function(e) {
      //  $upload.http({
      //    url: window.talk_upload_url,
      //    headers: {'Content-Type': file.type,
      //              'key': window.talk_uuid },
      //    data: e.target.result
      //  }).then(function(response) {
      //    //success;
      //    console.log("All done!");
      //  }, null, function(evt) {
      //    progress = parseInt(100.0 * evt.loaded / evt.total);
      //    $scope.progress[index] = progress;
      //    window.alert("progress: " + progress);
      //    console.log('percent: ' + progress);
      //  });
      //}

    }
  };
}

uploadFunc.$inject = ['$scope', '$upload'];

window.Sencha.controller('UploadCtrl', uploadFunc);
