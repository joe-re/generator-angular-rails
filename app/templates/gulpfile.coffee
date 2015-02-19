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
reload   = server.reload;
inject  = require 'gulp-inject'

knownOptions =
  string: 'env',
  default: { env: process.env.NODE_ENV || 'development' }

gulp.option = minimist(process.argv.slice(2), knownOptions);
gulp.isProduction = -> gulp.option.env == 'production'

gulp.path =
  app: 'ngapp'
  dest: 'public'

gulp.task 'clean', (cb)->
  rimraf(@path.dest, cb)

gulp.task 'html', ->
  gulp.src "#{@path.app}/index.html"
    .pipe gulp.dest("#{@path.dest}/")

  gulp.src "#{@path.app}/views/**/*.html"
    .pipe gulp.dest("#{@path.dest}/views/")

gulp.task 'image', ->
  gulp.src "#{@path.app}/images/*"
    .pipe gulp.dest("#{@path.dest}/images/")

gulp.task 'bower',['html'], ->
  target = gulp.src "#{@path.dest}/index.html"
  src = gulp.src(bower(), { base: "#{@path.app}/bower_components"})
  bowerJs = src.pipe filter('**/*.js')
    .pipe _if @isProduction(), uglify({preserveComments:'some'})
    .pipe concat('bower_components.js')
    .pipe gulp.dest("#{@path.dest}/lib")

  bowerCss = src.pipe filter('**/*.css')
    .pipe _if @isProduction(), cssmin({keepBreaks:true})
    .pipe concat('bower_components.css')
    .pipe gulp.dest("#{@path.dest}/lib")

  target.pipe inject(bowerJs)
    .pipe inject(bowerCss)
    .pipe gulp.dest(@path.dest)

  src.pipe filter('**/*.map')
    .pipe flatten()
    .pipe gulp.dest("#{@path.dest}/lib")

  # for font-awesome
  src.pipe filter("font-awesome/fonts/*")
    .pipe flatten()
    .pipe gulp.dest("#{@path.dest}/fonts")

gulp.task 'sass', ->
  gulp.src "#{@path.app}/styles/**/*.scss"
    .pipe sass()
    .pipe _if @isProduction(), cssmin({keepBreaks:true})
    .pipe concat('main.css')
    .pipe gulp.dest("#{@path.dest}/styles")

gulp.task 'coffee', ->
  gulp.src "#{@path.app}/**/*.coffee"
    .pipe coffee()
    .pipe gulp.dest("#{@path.dest}/")

gulp.task 'inject', ->
  # for karma
  src = gulp.src(bower(), { base: "#{@path.app}/bower_components"}).pipe filter('**/*.js')
  karmaConf = gulp.src("#{@path.app}/test/karma.conf.coffee").pipe coffee()
  return karmaConf.pipe(inject(src))
    .pipe(gulp.dest('public'))

gulp.task 'serve', ->
  server(
    proxy: 'localhost:3000' # specify rails server
    port: '8000'
  )
  gulp.watch("#{@path.app}/**/*.html", ['copy', reload]);
  gulp.watch("#{@path.app}/**/*.coffee", ['coffee', reload]);
  gulp.watch("#{@path.app}/**/*.scss", ['sass', reload]);


gulp.task 'build', ['clean'], ->
  gulp.start ['image', 'bower', 'coffee', 'sass']
