module.exports = (config) ->
  config.set
    browsers: ['PhantomJS']
    basePath: '../..'
    frameworks: ['jasmine']
    autoWatch: true
    files: [
      'spec/javascripts/support/jquery.js',
      #'spec/javascripts/support/private_pub.js',
      'vendor/assets/javascripts/swfobject.js',
      'vendor/assets/javascripts/state-machine.min.js',
      'vendor/assets/javascripts/angular.js',
      'spec/javascripts/support/angular-mocks.js',
      'app/assets/javascripts/livepage.js.coffee',
      'app/assets/javascripts/angular/**/*',
      'spec/javascripts/config_mock.js',
      'spec/javascripts/*_spec.js.coffee'
    ]
