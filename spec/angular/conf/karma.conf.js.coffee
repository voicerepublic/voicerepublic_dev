module.exports = (config) ->
  config.set
    browsers: ['PhantomJS', 'Chrome']
    basePath: '../../../'
    frameworks: ['jasmine']

    reporters: ['dots', 'progress', 'junit']

    junitReporter:
      outputFile: 'test-results.xml'

    autoWatch: true
    plugins: ['karma-phantomjs-launcher', 'karma-chrome-launcher', 'karma-jasmine', 'karma-coffee-preprocessor', 'karma-junit-reporter']
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
      'spec/javascripts/config_mock.js',
      'angular/*/*.coffee',

      # tests
      'spec/angular/specs/unit/*/*.coffee'
    ]
    exclude: [
      # excluded bcs so many changes in logic and tests not edited!!!
      "spec/angular/specs/unit/controllers/livepage-spec.js.coffee"
      "spec/angular/specs/unit/services/upstream-spec.js.coffee"
      "spec/angular/specs/unit/services/session-spec.js.coffee"
      "spec/angular/specs/unit/services/private_pub-spec.js.coffee"
      "spec/angular/specs/unit/services/blackbox-spec.js.coffee"
    ]
