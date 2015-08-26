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

  # this need to be called via ng-init, preferably on the controller
  # node. options is an object with uploadUrl, key, filter, success,
  # and safetynetMessage
  $scope.init = (options) ->

    # split filter into array
    filetypes = options.filter.split ' '

    # make options available via $scope (although we don't use that!)
    $scope.options = options

    uploader = $scope.uploader = new FileUploader
      url: options.uploadUrl
      method: "PUT"
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
      $scope.state = 'uploading'
      $scope.addingFailed = false
      $scope.set_valid false
      safetynet.activate options.safetynetMessage

    uploader.onErrorItem = (fileItem, response, status, headers) ->
      $log.error "Uploading failed: " + JSON.stringify(response)
      $scope.uploadFailed = true
      safetynet.deactivate()

    uploader.onCompleteAll = ->
      $scope.state = 'finished'
      $scope.set_valid true
      # call the success pseudo callback given via options by eval
      eval(options.success)

uploadFunc.$inject = ["$scope", "$log", "FileUploader", "validity", "safetynet"]
window.sencha.controller "UploadController", uploadFunc
