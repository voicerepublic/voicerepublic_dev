# Using angularjs file upload, look it up here:
#   https://github.com/nervgh/angular-file-upload
uploadFunc = ($scope, $log, FileUploader) ->
  # Initialize scope variables
  $scope.addingFailed = false
  $scope.audioUploadFailed = false
  $scope.state = 'ready'

  uploader = $scope.uploader = new FileUploader
    url: window.talk_upload_url
    method: "POST"
    formData: [key: window.talk_uuid]
    queueLimit: 1
    autoUpload: true

  uploader.filters.push
    name: "fileFilter"
    fn: (item, options) -> #{File|FileLikeObject}
      type = "|" + item.type.slice(item.type.lastIndexOf("/") + 1) + "|"
      #console.log(item.type)
      "|ogg|x-ogg|wav|x-wav|wave|x-pn-wav|m4a|x-m4a|mp3|x-mp3|mpeg3|x-mpeg3|mpg|x-mpegaudio|mpeg|".indexOf(type) isnt -1

  uploader.onCancelItem = (item, response, status, headers) ->
    deactivateSafetynet()
    enableRecordField()

  uploader.onWhenAddingFileFailed = (item, filter, options) -> #{File|FileLikeObject}
    $scope.addingFailed = true

  uploader.onAfterAddingFile = (fileItem) ->
    $scope.addingFailed = false
    $scope.talkForm.$valid = false
    activateSafetynet()
    disableRecordField()
    $scope.state = 'uploading'

  uploader.onErrorItem = (fileItem, response, status, headers) ->
    $log.error "Uploading failed: " + JSON.stringify(response)
    $scope.audioUploadFailed = true
    deactivateSafetynet()

  uploader.onCompleteAll = ->
    # Set the talk UUID, so that the backend knows to expect a talk that has
    # an override set.
    $scope.state = 'finished'
    $("#talk_user_override_uuid").attr "value", window.talk_uuid
    $scope.talkForm.$valid = true

  # TODO resolve dependency on `window` by using `$window`
  activateSafetynet = ->
    $(window).bind "beforeunload", ->
      window.unprocessed_upload

  deactivateSafetynet = ->
    $(window).unbind 'beforeunload'

  $scope.deactivateSafetynet = deactivateSafetynet

  enableRecordField = ->
    $('.talk_collect').show()

  disableRecordField = ->
    $('.talk_collect').hide()

uploadFunc.$inject = [
  "$scope"
  "$log"
  "FileUploader"
]
window.Sencha.controller "UploadCtrl", uploadFunc
