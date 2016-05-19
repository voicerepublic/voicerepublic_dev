# Using angularjs file upload, look it up here:
#
#     https://github.com/nervgh/angular-file-upload
#
uploadFunc = ($scope, $log, FileUploader, validity, safetynet) ->

  $log.info 'init'

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
    filetypes = options.filter.split '|'

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
        type = item.type.split('/').pop()
        # fallback to file name, safari does not provide a type
        type = item.name.split('.').pop() if !type
        type in filetypes

    uploader.filters.push
      name: "fileSizeFilter"
      fn: (item, options) ->
        item.size > 0

    uploader.onWhenAddingFileFailed = (file, filter, options) ->
      $log.info 'adding failed'
      $scope.addingFailed = true

    uploader.onAfterAddingFile = (item) ->
      $log.info 'after adding'
      $scope.state = 'uploading'
      $scope.addingFailed = false
      $scope.set_valid false
      safetynet.activate options.safetynetMessage
      file = item?.file # because here item is a FileItem

    # uploader.onProgressItem = (item, progress) ->
    #   return unless progress %% 10 == 0
    #   file = item?.file

    uploader.onCancelItem = (item, response, status, headers) ->
      $log.info 'cancel'
      safetynet.deactivate()
      file = item?.file # because here item is a FileItem

    uploader.onErrorItem = (item, response, status, headers) ->
      $log.info 'error item'
      $log.error "Uploading failed: " + JSON.stringify(response)
      safetynet.deactivate()
      file = item?.file # because here item is a FileItem
      $scope.uploadFailed = true

    uploader.onCompleteAll = ->
      $log.info 'complete all'
      $scope.state = 'finished'
      $scope.set_valid true
      # call the success pseudo callback given via options by eval
      eval(options.success)

uploadFunc.$inject = ["$scope", "$log", "FileUploader", "validity", "safetynet"]
window.sencha.controller "UploadController", uploadFunc
