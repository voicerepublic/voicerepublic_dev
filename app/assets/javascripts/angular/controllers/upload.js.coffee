# Using angularjs file upload, look it up here:
#
#     https://github.com/nervgh/angular-file-upload
#
uploadFunc = ($scope, $log, FileUploader, validity, safetynet, messaging, config) ->

  username = config.user.name

  audit = (event, options) ->
    delete options.file._createFromFakePath if options? and options.file?
    messaging.publish jQuery.extend({ username, event }, options)

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
      method: "POST"
      formData: [key: options.key]
      queueLimit: 1
      autoUpload: true

    uploader.filters.push
      name: "fileFormatFilter"
      # `item` is either a File or a FileLikeObject
      fn: (item, options) ->
        item.type.split('/')[1] in filetypes

    uploader.filters.push
      name: "fileSizeFilter"
      fn: (item, options) ->
        item.size > 0

    uploader.onWhenAddingFileFailed = (file, filter, options) ->
      $scope.addingFailed = true
      audit 'upload-adding-file-failed', {filter, file}

    uploader.onAfterAddingFile = (item) ->
      $scope.state = 'uploading'
      $scope.addingFailed = false
      $scope.set_valid false
      safetynet.activate options.safetynetMessage
      file = item.file # because here item is a FileItem
      audit 'upload-after-adding-file', {file}

    uploader.onProgressItem = (item, progress) ->
      return unless progress %% 10 == 0
      file = item.file
      audit 'upload-progress-item', {file, progress}

    uploader.onCancelItem = (item, response, status, headers) ->
      safetynet.deactivate()
      file = item.file # because here item is a FileItem
      audit 'upload-cancel-item', {file, response, status, headers}

    uploader.onErrorItem = (item, response, status, headers) ->
      $log.error "Uploading failed: " + JSON.stringify(response)
      $scope.uploadFailed = true
      safetynet.deactivate()
      file = item.file # because here item is a FileItem
      audit 'upload-error-item', {file, response, status, headers}

    uploader.onCompleteAll = ->
      $scope.state = 'finished'
      $scope.set_valid true
      # call the success pseudo callback given via options by eval
      eval(options.success)
      audit 'upload-complete-all'

    audit 'upload-initialized'
    messaging.commitSub()

uploadFunc.$inject = ["$scope", "$log", "FileUploader", "validity", "safetynet",
  "messaging", "config"]
window.sencha.controller "UploadController", uploadFunc
