'use strict'

beforeEach window.module 'sencha'

describe 'upload-spec', ->
  $controller = undefined
  $log = undefined
  FileUploader = undefined
  # save repetitions
  $scope = undefined
  UploadCtrl = undefined

  beforeEach window.inject (_$controller_, _$log_, _FileUploader_, _validity_) ->
    $controller = _$controller_
    $log = _$log_
    FileUploader = _FileUploader_

    #preparation for test purpose (else: undefined)
    window.talk_upload_url = 'any_upload_url.net'
    window.talk_uuid = 1337

  beforeEach ->
    $scope = {}
    UploadCtrl = $controller 'UploadController', {$scope: $scope}

  it 'FileUploader should be defined', ->
    expect(FileUploader).toBeDefined()
    expect(FileUploader).toEqual jasmine.any Function

  it 'UploadCtrl & $scope should be defined', ->
    expect(UploadCtrl).toBeDefined()
    expect(UploadCtrl).toEqual jasmine.any Function

    expect($scope).toBeDefined()
    expect($scope).toEqual jasmine.any Object

  describe '- Under test: initialized defaults -', ->

    it '$scope variables should have been set properly', ->
      expect($scope.addingFailed).toBeFalsy()
      expect($scope.audioUploadFailed).toBeFalsy()
      expect($scope.state).toEqual 'ready'

      expect($scope.deactivateSafetynet).toBeDefined()
      expect($scope.deactivateSafetynet).toEqual jasmine.any Function

    it '$scope.uploader should have been initialized properly', ->
      uploader = $scope.uploader

      expect(uploader).toBeDefined()
      expect(uploader).toEqual jasmine.any Object
      expect(uploader instanceof FileUploader).toBeTruthy()

      expect(uploader.url).toEqual window.talk_upload_url
      expect(uploader.formData).toEqual [key: window.talk_uuid]

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
        'type': 'ogg'

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

      expect($scope.audioUploadFailed).toBeTruthy()

      expect($log.error.logs).toContain ["Uploading failed: " + JSON.stringify(response)]

    it 'check the uploader onCompleteAll functionality', ->
      uploader.onCompleteAll()

      expect($scope.state).toEqual 'finished'
      expect($scope.valid()).toBeTruthy()
