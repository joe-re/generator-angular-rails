'use strict';
var yeoman = require('yeoman-generator');
var chalk = require('chalk');
var yosay = require('yosay');
var BaseGenerator = require('../generator-base');

module.exports = BaseGenerator.extend({
  initializing: function () {
    this.pkg = require('../package.json');
  },

  prompting: function () {
    var done = this.async();

    // Have Yeoman greet the user.
    this.log(yosay('Welcome to the classy' + chalk.red('AngularRails') + ' generator!'));

    var prompts = [{
      name: 'appName',
      message: "What's your apps name?",
      default: 'ngApp'
    }];

    this.prompt(prompts, function (props) {
      this._appName = props.appName;

      done();
    }.bind(this));
  },

  writing: {
    app: function () {
      this.write('_package.json', 'package.json');
      this.write('_bower.json', 'bower.json');
      this.write('gulpfile.coffee', 'gulpfile.coffee');
      this.write('ngapp', 'ngapp');
      this.directory('images', 'ngapp/images');
      this.directory('ngtest', 'ngtest');
    },

    projectfiles: function () {
      this.write('editorconfig', '.editorconfig');
      this.write('jshintrc', '.jshintrc');
      this.write('bowerrc', '.bowerrc');
    }
  },

  install: function () {
    this.installDependencies({
      skipInstall: this.options['skip-install']
    });
    // generate default controllers
    this.composeWith('angular:controller', { args: ['main'] });
    this.composeWith('angular:controller', { args: ['about'] });
  }
});
