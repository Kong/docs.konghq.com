'use strict'

var browserSync = require('browser-sync').create()
var childProcess = require('child_process')
var log = require('fancy-log')
var del = require('del')
var ghPages = require('gh-pages')
var gulp = require('gulp')
var path = require('path')
var fs = require('fs')
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

var reload = done => {
  browserSync.reload()
  done()
}

/* Functions
--------------------------------------- */

// Basic Tasks
function css() {
  return gulp.src(paths.assets + 'css/*.css')
    .pipe(gulp.dest(paths.dist + 'assets'))
}

function styles() {
  return gulp.src(paths.assets + 'stylesheets/index.less')
    .pipe($.plumber())
    .pipe($.if(dev, $.sourcemaps.init()))
    .pipe($.less())
    .pipe($.autoprefixer())
    // .pipe($.purifycss([dest.html], {
    //   whitelist: [
    //     '.affix',
    //     '.alert',
    //     '.close',
    //     '.collaps',
    //     '.fade',
    //     '.has',
    //     '.help',
    //     '.in',
    //     '.modal',
    //     '.open',
    //     '.popover',
    //     '.tooltip'
    //   ]
    // }))
    .pipe($.cleanCss({ compatibility: 'ie8' }))
    .pipe($.rename('styles.css'))
    .pipe($.if(dev, $.sourcemaps.write()))
    .pipe(gulp.dest(paths.dist + 'assets'))
    .pipe($.size())
    .pipe(browserSync.stream())
}

function js() {
  return gulp.src(sources.js)
    .pipe($.plumber())
    .pipe($.if(dev, $.sourcemaps.init()))
    .pipe($.concat('app.js'))
    .pipe($.if(dev, $.sourcemaps.write()))
    .pipe(gulp.dest('dist/assets'))
    .pipe(browserSync.stream())
}

function js_min() {
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
}

function images() {
  return gulp.src(sources.images)
    .pipe($.plumber())
    .pipe(gulp.dest(paths.dist + 'assets/images'))
}

function images_min() {
  return gulp.src(sources.images)
  .pipe($.plumber())
  .pipe($.imagemin())
  .pipe(gulp.dest(paths.dist + 'assets/images'))
  .pipe($.size())
}

function fonts() {
  return gulp.src(sources.fonts)
    .pipe($.plumber())
    .pipe(gulp.dest(paths.dist + 'assets/fonts'))
    .pipe($.size())
    .pipe(browserSync.stream())
}

function jekyll(cb) {
  var command = 'bundle exec jekyll build --config jekyll.yml --profile --destination ' + paths.dist

  childProcess.exec(command, function (err, stdout, stderr) {
    log(stdout)
    log(stderr)
    cb(err)
  })
}

function jekyll_dev(cb) {
  var command = 'bundle exec jekyll build --config jekyll-dev.yml --profile --destination ' + paths.dist

  childProcess.exec(command, function (err, stdout, stderr) {
    log(stdout)
    log(stderr)
    cb(err)
  })
}

function html() {
  return gulp.src(paths.dist + '/**/*.html')
    .pipe($.plumber())
    .pipe(gulp.dest(paths.dist))
    .pipe($.size())
}

// Custom Tasks
function browser_sync(done) {
  browserSync.init({
    logPrefix: ' ▶ ',
    minify: false,
    notify: false,
    server: 'dist',
    open: false
  })
  done()
}

function gh_pages(cb) {
  var cmd = 'git rev-parse --short HEAD'

  childProcess.exec(cmd, function (err, stdout, stderr) {
    if (err) {
      cb(err)
    }

    ghPages.publish(path.join(__dirname, paths.dist), {
      message: 'Deploying ' + stdout + '(' + new Date().toISOString() + ')'
    }, cb)
  })
}

function cloudflare(cb) {
  // configure cloudflare
  var cloudflare = require('cloudflare').createClient({
    email: process.env.MASHAPE_CLOUDFLARE_EMAIL,
    token: process.env.MASHAPE_CLOUDFLARE_TOKEN
  })

  cloudflare.clearCache('docs.getkong.com', function (err) {
    if (err) {
      log(err.message)
    }

    cb()
  })
}

function clean() {
  ghPages.clean()
  return del(['dist', '.gh-pages'])
}

function watch_files() {
  gulp.watch(sources.content, gulp.series(jekyll, html, reload))
  gulp.watch(sources.styles, styles)
  gulp.watch(sources.images, gulp.series(images, reload))
  gulp.watch(sources.js, gulp.series(js, reload))
  gulp.watch(paths.assets + 'css/hub.css', css)
}

function set_dev(cb) {
  dev = true
  cb()
}

/*----------------------------------------*/

// Basic Tasks
gulp.task("js", js)
gulp.task("js_min", js_min)
gulp.task("css", css)
gulp.task("styles", styles)
gulp.task("images", images)
gulp.task("images_min", images_min)
gulp.task("fonts", fonts)
gulp.task("jekyll", jekyll)
gulp.task("jekyll_dev", jekyll_dev)
gulp.task("html", html)

// Custom Tasks
gulp.task("browser_sync", browser_sync)
gulp.task("gh_pages", gh_pages)
gulp.task("cloudflare", cloudflare)
gulp.task("set_dev", set_dev)


// Gulp Commands
gulp.task("build", gulp.series(gulp.parallel(js, images, fonts, css), jekyll, html, styles))

gulp.task("watch", gulp.series(browser_sync, watch_files))

gulp.task("dev", gulp.series(set_dev, clean, gulp.parallel(js, images, fonts, css), jekyll, html, styles, browser_sync, watch_files))

gulp.task('default', gulp.series(clean, gulp.parallel(js, images, fonts, css), jekyll_dev, html, styles, browser_sync, watch_files))

gulp.task("deploy", gulp.series(gulp.parallel(js_min, images_min, fonts, css), jekyll, html, styles, gh_pages))
