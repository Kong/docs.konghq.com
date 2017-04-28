'use strict'

var browserSync = require('browser-sync').create()
var childProcess = require('child_process')
var gutil = require('gulp-util')
var del = require('del')
var ghPages = require('gh-pages')
var gulp = require('gulp')
var path = require('path')
var sequence = require('run-sequence')
var dev = false

// load gulp plugins
var $ = require('gulp-load-plugins')()

var paths = {
  assets: './app/_assets/',
  modules: './node_modules/',
  dist: './dist/'
}

// Sources
var sources = {
  content: 'app/**/*.{markdown,md,html,txt,yml,yaml}',
  styles: paths.assets + 'stylesheets/**/*',
  js: [
    paths.assets + 'javascripts/jquery.2.1.3.min.js',
    paths.assets + 'javascripts/app.js',
    paths.modules + 'bootstrap/js/dropdown.js',
    paths.modules + 'bootstrap/js/affix.js'
  ],
  images: paths.assets + 'images/**/*',
  fonts: [
    paths.modules + 'font-awesome/fonts/**/*.*',
    paths.assets + 'fonts/*.*'
  ]
}

// Destinations
var dest = {
  html: paths.dist + '**/*.html',
  js: paths.dist + 'assets/app.js'
}

gulp.task('styles', function () {
  return gulp.src(paths.assets + 'stylesheets/index.less')
    .pipe($.plumber())
    .pipe($.if(dev, $.sourcemaps.init()))
    .pipe($.less())
    .pipe($.autoprefixer())
    .pipe($.purifycss([dest.html], {
      whitelist: [
        '.affix',
        '.alert',
        '.close',
        '.collaps',
        '.fade',
        '.has',
        '.help',
        '.in',
        '.modal',
        '.open',
        '.popover',
        '.tooltip'
      ]
    }))
    .pipe($.cleanCss({ compatibility: 'ie8' }))
    .pipe($.rename('styles.css'))
    .pipe($.if(dev, $.sourcemaps.write()))
    .pipe(gulp.dest(paths.dist + 'assets'))
    .pipe($.size())
    .pipe(browserSync.stream())
})

gulp.task('javascripts', function () {
  return gulp.src(sources.js)
    .pipe($.plumber())
    .pipe($.if(dev, $.sourcemaps.init()))
    .pipe($.minify({
      noSource: true,
      ext: {
        min: '.js'
      }
    }))
    .pipe($.concat('app.js'))
    .pipe($.if(dev, $.sourcemaps.write()))
    .pipe(gulp.dest('dist/assets'))
    .pipe($.size())
    .pipe(browserSync.stream())
})

gulp.task('images', function () {
  return gulp.src(sources.images)
    .pipe($.plumber())
    .pipe($.imagemin())
    .pipe(gulp.dest(paths.dist + 'assets/images'))
    .pipe($.size())
})

gulp.task('fonts', function () {
  return gulp.src(sources.fonts)
    .pipe($.plumber())
    .pipe(gulp.dest(paths.dist + 'assets/fonts'))
    .pipe($.size())
    .pipe(browserSync.stream())
})

gulp.task('jekyll', function (cb) {
  var command = 'bundle exec jekyll build --config jekyll.yml --destination ' + paths.dist

  childProcess.exec(command, function (err, stdout, stderr) {
    gutil.log(stdout)
    gutil.log(stderr)
    cb(err)
  })
})

gulp.task('html', ['jekyll'], function () {
  return gulp.src(paths.dist + '/**/*.html')
    .pipe($.plumber())
    // Prefetch static assets
    .pipe($.resourceHints())
    .pipe(gulp.dest(paths.dist))
    .pipe($.size())
})

gulp.task('docs', function (cb) {
  if (process.env.KONG_PATH === undefined) {
    return cb('No KONG_PATH environment variable set')
  }

  var command = 'ldoc --quiet -c ./config.ld ' + process.env.KONG_PATH
  command += ' && rm lua-reference/ldoc.css'

  childProcess.exec(command, function (err, stdout, stderr) {
    gutil.log(stdout)
    gutil.log(stderr)
    cb(err)
  })
})

gulp.task('clean', function () {
  ghPages.clean()
  return del(['dist', '.gh-pages'])
})

gulp.task('build', ['javascripts', 'images', 'fonts'], function (cb) {
  sequence('html', 'styles', cb)
})

gulp.task('browser-sync', function () {
  browserSync.init({
    logPrefix: ' ▶ ',
    minify: false,
    notify: false,
    server: 'dist',
    open: false
  })
})

gulp.task('gh-pages', function (cb) {
  var cmd = 'git rev-parse --short HEAD'

  childProcess.exec(cmd, function (err, stdout, stderr) {
    if (err) {
      cb(err)
    }

    ghPages.publish(path.join(__dirname, paths.dist), {
      message: 'Deploying ' + stdout + '(' + new Date().toISOString() + ')'
    }, cb)
  })
})

gulp.task('cloudflare', function (cb) {
  // configure cloudflare
  var cloudflare = require('cloudflare').createClient({
    email: process.env.MASHAPE_CLOUDFLARE_EMAIL,
    token: process.env.MASHAPE_CLOUDFLARE_TOKEN
  })

  cloudflare.clearCache('getkong.org', function (err) {
    if (err) {
      gutil.log(err.message)
    }

    cb()
  })
})

gulp.task('deploy', function (cb) {
  sequence('build', 'gh-pages', cb)
})

gulp.task('watch', function () {
  gulp.watch(sources.content, ['html-watch'])
  gulp.watch(sources.styles, ['styles'])
  gulp.watch(sources.images, ['images-watch'])
  gulp.watch(sources.js, ['javascripts'])
})

gulp.task('html-watch', ['html'], function (cb) {
  browserSync.reload()
  cb()
})

gulp.task('images-watch', ['images'], function (cb) {
  browserSync.reload()
  cb()
})

gulp.task('default', ['clean'], function (cb) {
  sequence('build', 'browser-sync', 'watch', cb)
})

gulp.task('setdev', function (cb) {
  dev = true
  cb()
})

gulp.task('dev', ['setdev'], function (cb) {
  sequence('default', cb)
})
