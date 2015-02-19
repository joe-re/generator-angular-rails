'use strict';

var path = require('path');
var generators = require('yeoman-generator');

module.exports = generators.Base.extend({
  initialize: function() {
    this.sourceRoot(path.join(__dirname, './templates'));
  },
  appName: function () {
    if (this._appName) { return this._appName; }
    var bowerJson = {};
    try {
      bowerJson = require(path.join(process.cwd(), 'bower.json'));
    } catch (e) {}
    if (bowerJson.name) {
      this._appName = bowerJson.name;
    } else {
      this._appName = path.basename(process.cwd());
    }
    return this._appName;
  },
  write: function(srcPath, destPath) {
    this.fs.copyTpl(
      this.templatePath(srcPath),
      this.destinationPath(destPath),
      { appName: this.appName(), generateName: this._.camelize(this.name) }
    );
  }
});
