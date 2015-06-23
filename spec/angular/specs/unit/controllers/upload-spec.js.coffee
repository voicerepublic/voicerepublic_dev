'use strict'

beforeEach window.module 'sencha'

describe 'upload-spec', ->
  $controller = undefined
  $log = undefined
  FileUploader = undefined
  # save repetitions
  $scope = undefined
  UploadController = undefined

  beforeEach window.inject (_$controller_, _$log_, _FileUploader_) ->
    $controller = _$controller_
    $log = _$log_
    FileUploader = _FileUploader_

  beforeEach ->
    $scope = {}
    UploadController = $controller 'UploadController', {$scope: $scope}
    $scope.init
      uploadUrl: 'any_upload_url.net'
      key: 1337
      filter: 'any thing'

  it 'FileUploader should be defined', ->
    expect(FileUploader).toBeDefined()
    expect(FileUploader).toEqual jasmine.any Function

  it 'UploadController & $scope should be defined', ->
    expect(UploadController).toBeDefined()
    expect(UploadController).toEqual jasmine.any Function

    expect($scope).toBeDefined()
    expect($scope).toEqual jasmine.any Object

  describe '- Under test: initialized defaults -', ->

    it '$scope variables should have been set properly', ->
      expect($scope.addingFailed).toBeFalsy()
      expect($scope.uploadFailed).toBeFalsy()
      expect($scope.state).toEqual 'ready'

      expect($scope.deactivateSafetynet).toBeDefined()
      expect($scope.deactivateSafetynet).toEqual jasmine.any Function

    it '$scope.uploader should have been initialized properly', ->
      uploader = $scope.uploader

      expect(uploader).toBeDefined()
      expect(uploader).toEqual jasmine.any Object
      expect(uploader instanceof FileUploader).toBeTruthy()

      expect(uploader.url).toEqual 'any_upload_url.net'
      expect(uploader.formData).toEqual [key: 1337]

  describe '- Under test: uploader -', ->
    uploader = undefined

    beforeEach ->
      uploader = $scope.uploader
      #preparation of talkForm for test purpose (else: undefined)
      $scope.talkForm = {}

    it 'uploader.filters should contain fileFilter', ->
      expect(filter.name for filter in uploader.filters is 'fileFilter').toBeTruthy()

    it 'check the fileFilter for compatible format', ->
      item =
        'type': 'some/thing'

      fileFilter = (filter for filter in uploader.filters when filter.name is 'fileFilter')[0]

      val = fileFilter.fn item, null

      expect(val).toBeTruthy()

    it 'check the fileFilter for an uncompatible format', ->
      item =
        'type': 'imba_1337_format'

      fileFilter = (filter for filter in uploader.filters when filter.name is 'fileFilter')[0]

      val = fileFilter.fn item, null

      expect(val).toBeFalsy()

    it 'check the uploader onWhenAddingFileFailed functionality', ->
      uploader.onWhenAddingFileFailed null, null, null

      expect($scope.addingFailed).toBeTruthy()

    it 'check the uploader onAfterAddingFile functionality', ->
      uploader.onAfterAddingFile null

      expect($scope.addingFailed).toBeFalsy()
      expect($scope.talkForm.$valid).toBeFalsy()
      expect($scope.state).toEqual 'uploading'

    it 'check the uploader onErrorItem functionality', ->
      response =
        'code': 400
        'reason': 'invalidParameter'
        'message': 'Invalid Data format.'

      uploader.onErrorItem null, response, null, null

      expect($scope.uploadFailed).toBeTruthy()

      expect($log.error.logs).toContain ["Uploading failed: " + JSON.stringify(response)]

    it 'check the uploader onCompleteAll functionality', ->
      uploader.onCompleteAll()

      expect($scope.state).toEqual 'finished'
      expect($scope.valid()).toBeTruthy()
