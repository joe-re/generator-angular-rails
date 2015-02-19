'use strict';

var path = require('path');
var assert = require('yeoman-generator').assert;
var helpers = require('yeoman-generator').test;
var os = require('os');

describe('angular-rails:app', function () {
  before(function (done) {
    var deps = [
        [helpers.createDummyGenerator(), 'angular:controller']
      ];
    helpers.run(path.join(__dirname, '../app'))
      .inDir(path.join(os.tmpdir(), './temp-test'))
      .withOptions({ 'skip-install': true })
      .withGenerators(deps)
      .withPrompt({
        someOption: true
      })
      .on('end', done);
  });

  it('creates files', function () {
    assert.file([
      'bower.json',
      'package.json',
      '.editorconfig',
      '.jshintrc',
      'gulpfile.coffee',
      'ngapp/index.html',
      'ngapp/scripts/app.coffee',
      'ngapp/styles/main.scss',
      'ngapp/views/main.html',
      'ngapp/views/about.html',
      'ngtest/karma.conf.coffee',
    ]);
  });
});
