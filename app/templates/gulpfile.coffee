gulp     = require 'gulp'
coffee   = require 'gulp-coffee'
bower    = require 'main-bower-files'
uglify   = require 'gulp-uglify'
flatten  = require 'gulp-flatten'
_if      = require 'gulp-if'
minimist = require 'minimist'
concat   = require 'gulp-concat'
rimraf   = require 'rimraf'
filter   = require 'gulp-filter'
cssmin   = require 'gulp-minify-css'
sass     = require 'gulp-sass'
server   = require 'browser-sync'
reload   = server.reload
inject   = require 'gulp-inject'
rev      = require('gulp-rev')
htmlmin  = require 'gulp-minify-html'

knownOptions =
  string: 'env',
  default: { env: process.env.NODE_ENV || 'development' }

gulp.option = minimist(process.argv.slice(2), knownOptions)
gulp.isProduction = -> gulp.option.env == 'production'

gulp.path =
  app: 'ngapp'
  dest: 'public'

gulp.task 'clean', (cb)->
  rimraf(@path.dest, cb)

gulp.task 'index', ['copy', 'build:bower:js', 'build:bower:css', 'build:bower:other', 'build:sass', 'build:coffee'], ->
  gulp.src "#{@path.app}/index.html"
    .pipe inject(
      gulp.src(["#{@path.dest}/scripts/**/*.js", "#{@path.dest}/styles/**/*.css"]),
      { ignorePath: @path.dest }
    )
    .pipe _if @isProduction(), htmlmin()
    .pipe gulp.dest("#{@path.dest}/")

gulp.task 'copy', ->
  gulp.src "#{@path.app}/views/**/*.html"
    .pipe _if @isProduction(), htmlmin()
    .pipe gulp.dest("#{@path.dest}/views/")

  gulp.src "#{@path.app}/images/*"
    .pipe gulp.dest("#{@path.dest}/images/")

gulp.task 'build:bower:js', ->
  gulp.src(bower(filter: '**/*.js'), { base: "#{@path.app}/bower_components" })
    .pipe _if @isProduction(), uglify({preserveComments:'some'})
    .pipe concat('_vendor.js')
    .pipe rev()
    .pipe gulp.dest("#{@path.dest}/scripts")

gulp.task 'build:bower:css', ->
  gulp.src(bower(filter: '**/*.css'), { base: "#{@path.app}/bower_components" })
    .pipe _if @isProduction(), cssmin({keepBreaks:true})
    .pipe concat('_vendor.css')
    .pipe rev()
    .pipe gulp.dest("#{@path.dest}/styles")

gulp.task 'build:bower:other', ->
  src = gulp.src(bower(), { base: "#{@path.app}/bower_components" })
  src.pipe filter('**/*.map')
    .pipe flatten()
    .pipe gulp.dest("#{@path.dest}/styles")

  # for font-awesome
  src.pipe filter("font-awesome/fonts/*")
    .pipe flatten()
    .pipe gulp.dest("#{@path.dest}/fonts")

gulp.task 'build:sass', ->
  gulp.src "#{@path.app}/styles/**/*.scss"
    .pipe sass()
    .pipe _if @isProduction(), cssmin({keepBreaks:true})
    .pipe concat('main.css')
    .pipe rev()
    .pipe gulp.dest("#{@path.dest}/styles")

gulp.task 'build:coffee', ->
  gulp.src "#{@path.app}/**/*.coffee"
    .pipe coffee()
    .pipe _if @isProduction(), uglify({preserveComments:'some'})
    .pipe concat('main.js')
    .pipe rev()
    .pipe gulp.dest("#{@path.dest}/scripts")

gulp.task 'serve', ->
  server(
    proxy: 'localhost:3000' # specify rails server
    port: '8000'
  )
  gulp.watch("#{@path.app}/**/*.html", ['copy', reload])
  gulp.watch("#{@path.app}/**/*.coffee", ['build:coffee', reload])
  gulp.watch("#{@path.app}/**/*.scss", ['build:sass', reload])

gulp.task 'build', ['clean'], ->
  gulp.start ['index']
