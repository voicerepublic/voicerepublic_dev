module.exports = (config) ->
  config.set
    browsers: ['Chrome']
    basePath: '../../'
    frameworks: ['jasmine']
    autoWatch: true
    plugins: ['karma-chrome-launcher', 'karma-jasmine', 'karma-coffee-preprocessor']
    coffeePreprocessor:
      options:
        bare: false
        sourceMap: false
      transformPath: (path) ->
        path.replace /\.coffee$/, ""
    preprocessors: "**/*.coffee": ["coffee"]
    files: [
      'spec/javascripts/support/jquery.js',
      #'spec/javascripts/support/private_pub.js',
      'vendor/assets/javascripts/swfobject.js',
      'vendor/assets/javascripts/state-machine.min.js',
      'vendor/assets/javascripts/angular.js',
      'spec/javascripts/support/angular-mocks.js',
      'spec/javascripts/support/angular-file-upload.js',
      'app/assets/javascripts/sencha.js.coffee',
      'app/assets/javascripts/angular/**/*',
      #'spec/javascripts/config_mock.js',
      'angular_test/specs/unit/*/util-spec.js.coffee'
    ]