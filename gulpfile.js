'use strict'

var del = require('del')
var ghPages = require('gh-pages')
var glob = require('glob')
var gulp = require('gulp')
var path = require('path')
var process = require('child_process')
var sequence = require('run-sequence')

// load gulp plugins
var $ = require('gulp-load-plugins')()

// Build variables (default to local config)
var jekyllConfigs = {
  PROD: 'config/jekyll.yml',
  LOCAL: 'config/jekyll.local.yml'
}

var jekyllConfig = jekyllConfigs.LOCAL

// Sources
var sources = {
  content: 'app/**/*.{markdown,md,html,txt,yml,yaml}',
  styles: 'app/_assets/stylesheets/**/*.{less,css}',
  js: [
    'app/_assets/javascripts/**/*.js',
    'bower_components/bootstrap/js/dropdown.js',
    'bower_components/bootstrap/js/affix.js'
  ],
  images: 'app/_assets/images/**/*',
  fonts: 'bower_components/font-awesome/fonts/**/*.*'
}

gulp.task('styles', function () {
  // TODO: add LESS linting

  // thibaultcha:
  // 1. gulp-less has plugins (minifier and prefixer) we can run in $.less(plugins: [clean, prefix])
  // but they throw errors if we use them. Let's use gulp-autoprefixer and gulp-minify-css.
  // 2. If we want to use uncss, we need to minify after it runs, otherwise it unminifies the css
  // another reason not to use gulp-less plugins.
  // 3. the source maps still don't work if used along with gulp-autoprefixer
  // 4. uncss and gulpminify-css seem to behave fine and is not having an impact on sourcemaps
  return gulp.src('app/_assets/stylesheets/index.less')
    .pipe($.plumber())
    .pipe($.less())
    .pipe($.uncss({
      html: glob.sync('dist/**/*.html'),
      ignore: ['.open > .dropdown-menu', '.open > a', '.page-navigation .affix']
    }))
    .pipe($.autoprefixer())
    .pipe($.minifyCss())
    .pipe($.rename('styles.css'))
    .pipe(gulp.dest('dist/assets/'))
    .pipe($.size())
    .pipe($.connect.reload())
})

gulp.task('javascripts', function () {
  return gulp.src(sources.js)
    .pipe($.plumber())
    .pipe($.sourcemaps.init())
    .pipe($.concat('app.js'))
    .pipe($.uglify())
    .pipe($.sourcemaps.write('maps'))
    .pipe(gulp.dest('dist/assets'))
    .pipe($.size())
    .pipe($.connect.reload())
})

gulp.task('images', function () {
  return gulp.src(sources.images)
    .pipe($.plumber())
    .pipe(gulp.dest('dist/assets/images'))
    .pipe($.size())
    .pipe($.connect.reload())
})

gulp.task('fonts', function () {
  return gulp.src(sources.fonts)
      .pipe($.plumber())
      .pipe(gulp.dest('dist/assets/fonts'))
      .pipe($.size())
      .pipe($.connect.reload())
})

gulp.task('jekyll', function (next) {
  var command = 'bundle exec jekyll build --config ' + jekyllConfig + ' --destination dist'

  process.exec(command, function (err, stdout, stderr) {
    console.log(stdout)
    console.error(stderr)
    next(err)
  })
})

gulp.task('html', ['jekyll'], function () {
  return gulp.src('dist/**/*.html')
    .pipe($.plumber())
    .pipe($.htmlmin({
      minifyJS: true,
      minifyCSS: true,
      removeComments: true,
      collapseWhitespace: true,
      conservativeCollapse: true,
      removeEmptyAttributes: true,
      collapseBooleanAttributes: true,
      removeScriptTypeAttributes: true,
      removeStyleLinkTypeAttributes: true
    }))
    .pipe(gulp.dest('dist'))
    .pipe($.size())
    .pipe($.connect.reload())
})

gulp.task('clean', function (cb) {
  ghPages.clean()
  del(['dist', '.gh-pages'], cb)
})

gulp.task('build', ['javascripts', 'images', 'fonts'], function (cb) {
  sequence('html', 'styles', cb)
})

gulp.task('build:prod', function (cb) {
  jekyllConfig = jekyllConfigs.PROD
  sequence('build', cb)
})

gulp.task('connect', function () {
  $.connect.server({
    port: 9000,
    root: 'dist',
    livereload: true,
    fallback: 'dist/404.html'
  })
})

gulp.task('gh-pages', function (next) {
  var config = {
    message: 'Update ' + new Date().toISOString()
  }

  ghPages.publish(path.join(__dirname, 'dist'), config, next)
})

gulp.task('deploy:prod', function (cb) {
  sequence('build:prod', 'gh-pages', cb)
})

gulp.task('watch', function () {
  gulp.watch(sources.content, ['build'])
  gulp.watch(sources.styles, ['styles'])
  gulp.watch(sources.images, ['images'])
  gulp.watch(sources.js, ['javascripts'])
})

gulp.task('default', ['clean'], function (cb) {
  sequence('build', 'connect', 'watch', cb)
})
