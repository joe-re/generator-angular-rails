module.exports = (config) ->
  bowerFiles = require 'main-bower-files'
  files = [
    'ngapp/scripts/**/*.coffee'
    'ngtest/mock/**/*.coffee'
    'ngtest/spec/**/*.coffee'
  ]
  files = bowerFiles(includeDev: true, filter: '**/*.js').concat files
  config.set
    basePath: '../'
    frameworks: ['jasmine']
    files: files,
    exclude: [
    ]
    port: 8080
    logLevel: config.LOG_INFO
    browsers: [
      'PhantomJS'
    ]
    plugins: [
      'karma-phantomjs-launcher',
      'karma-jasmine',
      'karma-coffee-preprocessor'
    ]
    autoWatch: true
    singleRun: false
    colors: true
    preprocessors: '**/*.coffee': ['coffee']
