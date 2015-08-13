'use strict'

var del = require('del')
var ghPages = require('gh-pages')
var glob = require('glob')
var gulp = require('gulp')
var path = require('path')
var process = require('child_process')
var sequence = require('run-sequence')
var browserSync = require('browser-sync').create()

// load gulp plugins
var $ = require('gulp-load-plugins')()

// Sources
var sources = {
  content: 'app/**/*.{markdown,md,html,txt,yml,yaml}',
  styles: 'app/_assets/stylesheets/**/*.{less,css}',
  js: [
    'app/_assets/javascripts/**/*.js',
    'node_modules/bootstrap/js/dropdown.js',
    'node_modules/bootstrap/js/affix.js'
  ],
  images: 'app/_assets/images/**/*',
  fonts: 'node_modules/font-awesome/fonts/**/*.*'
}

gulp.task('styles', function () {
  // TODO: add LESS linting

  // thibaultcha:
  // 1. gulp-less has plugins (minifier and prefixer) we can run in $.less(plugins: [clean, prefix])
  // but they throw errors if we use them. Let's use gulp-autoprefixer and gulp-minify-css.
  // 2. the source maps still don't work if used along with gulp-autoprefixer
  return gulp.src('app/_assets/stylesheets/index.less')
    .pipe($.plumber())
    .pipe($.less())
    .pipe($.autoprefixer())
    .pipe($.rename('styles.css'))
    .pipe(gulp.dest('dist/assets/'))
    .pipe($.size())
    .pipe(browserSync.stream())
})

gulp.task('javascripts', function () {
  return gulp.src(sources.js)
    .pipe($.plumber())
    .pipe($.sourcemaps.init())
    .pipe($.concat('app.js'))
    .pipe($.sourcemaps.write('maps'))
    .pipe(gulp.dest('dist/assets'))
    .pipe($.size())
    .pipe(browserSync.stream())
})

gulp.task('images', function () {
  return gulp.src(sources.images)
    .pipe($.plumber())
    .pipe(gulp.dest('dist/assets/images'))
    .pipe($.size())
    .pipe(browserSync.stream())
})

gulp.task('fonts', function () {
  return gulp.src(sources.fonts)
    .pipe($.plumber())
    .pipe(gulp.dest('dist/assets/fonts'))
    .pipe($.size())
    .pipe(browserSync.stream())
})

gulp.task('jekyll', function (next) {
  var command = 'bundle exec jekyll build --config jekyll.yml --destination dist'

  process.exec(command, function (err, stdout, stderr) {
    console.log(stdout)
    console.error(stderr)
    next(err)
  })
})

gulp.task('html', ['jekyll'], function () {
  return gulp.src('dist/**/*.html')
    .pipe($.plumber())
    .pipe(gulp.dest('dist'))
    .pipe($.size())
    .pipe(browserSync.stream())
})

gulp.task('clean', function (cb) {
  ghPages.clean()
  del(['dist', '.gh-pages'], cb)
})

gulp.task('build', ['javascripts', 'images', 'fonts'], function (cb) {
  sequence('html', 'styles', cb)
})

gulp.task('browser-sync', function () {
  browserSync.init({
    logPrefix: ' ▶ ',
    minify: false,
    notify: false,
    server: 'dist'
  })
})

gulp.task('gh-pages', function (next) {
  var config = {
    message: 'Update ' + new Date().toISOString()
  }

  ghPages.publish(path.join(__dirname, 'dist'), config, next)
})

gulp.task('deploy', function (cb) {
  sequence('build', 'gh-pages', cb)
})

gulp.task('watch', function () {
  gulp.watch(sources.content, ['html'])
  gulp.watch(sources.styles, ['styles'])
  gulp.watch(sources.images, ['images'])
  gulp.watch(sources.js, ['javascripts'])
})

gulp.task('default', ['clean'], function (cb) {
  sequence('build', 'browser-sync', 'watch', cb)
})
