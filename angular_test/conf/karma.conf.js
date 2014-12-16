module.exports = function(config){
  config.set({

    basePath : '../../',

    preprocessors: {
      '**/*.coffee': ['coffee']
    },

    coffeePreprocessor: {
      // options passed to the coffee compiler
      options: {
        bare: true,
        sourceMap: false
      },
      // transforming the filenames
      transformPath: function(path) {
        return path.replace(/\.coffee$/, '');
      }
    },   

    files : [
      'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js',
      'http://ajax.googleapis.com/ajax/libs/angularjs/1.2.19/angular.min.js',
      'http://ajax.googleapis.com/ajax/libs/angularjs/1.2.19/angular-mocks.js',
      //'angular_test/angular-file-upload.min.js',
      'app/assets/javascripts/sencha.js.coffee',
      'app/assets/javascripts/angular/*/util.js.coffee',
      'angular_test/specs/unit/*/*.coffee'
    ],

    autoWatch : true,

    frameworks: ['jasmine'],

    browsers : ['Chrome'],

    plugins : [
            'karma-chrome-launcher',
            //'karma-firefox-launcher',
            'karma-jasmine',
            'karma-coffee-preprocessor'
            ],

    junitReporter : {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    }
  });
};