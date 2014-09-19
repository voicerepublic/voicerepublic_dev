# Using angularjs file upload, look it up here:
#   https://github.com/nervgh/angular-file-upload
uploadFunc = ($scope, $log, FileUploader) ->
  $scope.addingFailed = false
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
      "|ogg|wav|mp3|m4a|".indexOf(type) isnt -1

  uploader.onCancelItem = (item, response, status, headers) ->
    deactivateSafetynet()
    enabeleRecordField()

  uploader.onWhenAddingFileFailed = (item, filter, options) -> #{File|FileLikeObject}
    $scope.addingFailed = true

  uploader.onAfterAddingFile = (fileItem) ->
    # TODO: Add uuid to hidden field
    # TODO: Lock form to not be via Angular Safetynet
    $scope.addingFailed = false
    $scope.talkForm.$valid = false
    activateSafetynet()
    disableRecordField()

  uploader.onErrorItem = (fileItem, response, status, headers) ->
    # TODO: Show Error
    $log.error "Uploading failed: " + JSON.stringify(response)

  uploader.onCompleteAll = ->

    # Set the talk UUID, so that the backend knows to expect a talk that has
    # an override set.
    $("#talk_user_override_uuid").attr "value", window.talk_uuid
    $scope.talkForm.$valid = true

  # TODO resolve dependency on `window` by using `$window`
  activateSafetynet = ->
    $(window).bind "beforeunload", ->
      window.unprocessed_upload

  deactivateSafetynet = ->
    $(window).unbind 'beforeunload'

  enabeleRecordField = ->
    $('.talk_collect').show()

  disableRecordField = ->
    $('.talk_collect').hide()

uploadFunc.$inject = [
  "$scope"
  "$log"
  "FileUploader"
]
window.Sencha.controller "UploadCtrl", uploadFunc
