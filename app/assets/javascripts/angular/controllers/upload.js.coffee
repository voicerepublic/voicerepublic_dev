# Using angularjs file upload, look it up here:
#
#     https://github.com/nervgh/angular-file-upload
#
uploadFunc = ($scope, $log, FileUploader, validity, safetynet) ->

  # initialize scope variables
  $scope.addingFailed = false
  $scope.uploadFailed = false
  $scope.state = 'ready'

  $scope.set_valid = validity.register(true)
  $scope.valid = validity.valid # (this is only used in specs!)

  $scope.init = (options) ->

    # split filter into array
    filetypes = options.filter.split(' ')

    # make options available via $scope (although we don't use that!)
    $scope.options = options

    uploader = $scope.uploader = new FileUploader
      url: options.uploadUrl
      method: "POST"
      formData: [key: options.key]
      queueLimit: 1
      autoUpload: true

    uploader.filters.push
      name: "fileFilter"
      # `item` is either a File or a FileLikeObject
      fn: (item, options) ->
        item.type.split('/')[1] in filetypes

    uploader.onCancelItem = (item, response, status, headers) ->
      safetynet.deactivate()

    uploader.onWhenAddingFileFailed = (item, filter, options) ->
      $scope.addingFailed = true

    uploader.onAfterAddingFile = (fileItem) ->
      $scope.addingFailed = false
      $scope.set_valid false
      safetynet.activate()
      $scope.state = 'uploading'

    uploader.onErrorItem = (fileItem, response, status, headers) ->
      $log.error "Uploading failed: " + JSON.stringify(response)
      $scope.uploadFailed = true
      safetynet.deactivate()

    uploader.onCompleteAll = ->
      # Set the talk UUID, so that the backend knows to expect a talk
      # that has an override set.
      $scope.state = 'finished'
      $("#talk_user_override_uuid").attr "value", window.talk_uuid
      $scope.set_valid true

  $scope.deactivateSafetynet = safetynet.deactivate

uploadFunc.$inject = ["$scope", "$log", "FileUploader", "validity", "safetynet"]
window.sencha.controller "UploadController", uploadFunc
