"use strict";

var browserSync = require("browser-sync").create();
var childProcess = require("child_process");
var log = require("fancy-log");
var del = require("del");
var ghPages = require("gh-pages");
var gulp = require("gulp");
var path = require("path");
var fs = require("fs");
var dev = false;

// load gulp plugins
var $ = require("gulp-load-plugins")();

var paths = {
  assets: "./app/_assets/",
  modules: "./node_modules/",
  dist: "./dist/",
};

// Sources
var sources = {
  content: "app/**/*.{markdown,md,html,txt,yml,yaml}",
  styles: paths.assets + "stylesheets/**/*",
  js: [
    paths.assets + "javascripts/jquery-3.6.0.min.js",
    paths.assets + "javascripts/app.js",
    paths.assets + "javascripts/subscribe.js",
    paths.assets + "javascripts/editable-code-snippet.js",
    paths.assets + "javascripts/navbar.js",
    paths.assets + "javascripts/promo-banner.js",
    paths.assets + "javascripts/copy-code-snippet-support.js"
  ],
  images: paths.assets + "images/**/*",
  fonts: [
    paths.modules + "font-awesome/fonts/**/*.*",
    paths.assets + "fonts/*.*",
  ],
};

// Destinations
var dest = {
  html: paths.dist + "**/*.html",
  js: paths.dist + "assets/app.js",
};

/* Functions
--------------------------------------- */

// Basic Tasks
function css() {
  return gulp
    .src(paths.assets + "css/*.css")
    .pipe(gulp.dest(paths.dist + "assets"));
}

function styles() {
  return gulp
    .src(paths.assets + "stylesheets/index.less")
    .pipe($.plumber())
    .pipe($.if(dev, $.sourcemaps.init()))
    .pipe($.less())
    .pipe($.autoprefixer())
    .pipe($.cleanCss({ compatibility: "ie8" }))
    .pipe($.rename("styles.css"))
    .pipe($.if(dev, $.sourcemaps.write()))
    .pipe(gulp.dest(paths.dist + "assets"))
    .pipe($.size())
    .pipe(browserSync.stream());
}

function js() {
  return gulp
    .src(sources.js)
    .pipe($.plumber())
    .pipe($.if(dev, $.sourcemaps.init()))
    .pipe(
      $.if(
        !dev,
        $.minify({
          noSource: true,
          ext: {
            min: ".js",
          },
        })
      )
    )
    .pipe($.concat("app.js"))
    .pipe($.if(dev, $.sourcemaps.write()))
    .pipe(gulp.dest("dist/assets"))
    .pipe($.if(!dev, $.size()))
    .pipe(browserSync.stream());
}

function images() {
  return gulp
    .src(sources.images)
    .pipe($.plumber())
    .pipe($.if(!dev, $.imagemin()))
    .pipe(gulp.dest(paths.dist + "assets/images"))
    .pipe($.if(!dev, $.size()));
}

function fonts() {
  return gulp
    .src(sources.fonts)
    .pipe($.plumber())
    .pipe(gulp.dest(paths.dist + "assets/fonts"))
    .pipe($.if(!dev, $.size()))
    .pipe(browserSync.stream());
}

function jekyll(cb) {
  var profile = "";
  if (dev) {
    profile = "-dev";
  }

  var command =
    `bundle exec jekyll build --config jekyll${profile}.yml --profile --destination ` +
    paths.dist;

  childProcess.exec(command, function (err, stdout, stderr) {
    log(stdout);
    log(stderr);
    cb(err);
  });
}

function html() {
  return gulp
    .src(paths.dist + "/**/*.html")
    .pipe($.plumber())
    .pipe(gulp.dest(paths.dist))
    .pipe($.if(!dev, $.size()));
}

// Lua Tasks
function pdk_docs(cb) {
  var KONG_PATH,
    KONG_VERSION,
    navFilepath,
    doc,
    pdkRegex,
    newNav,
    newDoc,
    cmd,
    obj,
    errLog,
    refDir,
    modules,
    gitSha1,
    confFilepath;

  // 0 Obtain "env-var params"
  KONG_PATH = process.env.KONG_PATH;
  if (KONG_PATH === undefined) {
    return cb("No KONG_PATH environment variable set");
  }

  KONG_VERSION = process.env.KONG_VERSION;
  if (KONG_VERSION === undefined) {
    return cb("No KONG_VERSION environment variable set. Example: 0.14.x");
  }

  // 1. Update nav file
  // 1.1 Check that nav file exists
  navFilepath = "./app/_data/docs_nav_" + KONG_VERSION + ".yml";
  try {
    doc = fs.readFileSync(navFilepath, "utf8");
  } catch (err) {
    return cb("Could not find the file " + navFilepath + ". Err: " + err);
  }

  // 1.2 Check that nav file has the correct yaml entry
  pdkRegex = /[ ]+- text: Plugin Development Kit[\s\S]+\n-/gm;
  if (!doc.match(pdkRegex)) {
    return cb("Could not find the appropriate section in " + navFilepath);
  }

  // 1.3 Generate new yaml using ldoc
  cmd =
    'LUA_PATH="$LUA_PATH;./?.lua" ' +
    "ldoc -q -i --filter ldoc/filters.nav " +
    KONG_PATH +
    "/kong/pdk";
  obj = childProcess.spawnSync(cmd, { shell: true });
  // ignore "unkwnown tag" errors
  errLog = obj.stderr.toString().replace(/.*unknown tag.*\n/g, "");
  if (errLog.length > 0) {
    return cb(errLog);
  }

  // 1.4 Replace existing yaml with generated one
  newNav = obj.stdout.toString();
  newDoc = doc.replace(pdkRegex, newNav + "\n-");
  fs.writeFileSync(navFilepath, newDoc);
  log("Updated contents of " + navFilepath + " with new navigation items");

  // 2. Generate markdown docs using custom ldoc templates
  // 2.1 Prepare ref folder
  refDir = "app/" + KONG_VERSION + "/pdk";
  cmd = "rm -rf " + refDir + " && mkdir " + refDir;
  obj = childProcess.spawnSync(cmd, { shell: true });
  errLog = obj.stderr.toString();
  if (errLog.length > 0) {
    return cb(errLog);
  }

  // 2.2 Obtain the list of modules in json form & parse it
  cmd =
    'LUA_PATH="$LUA_PATH;./?.lua" ' +
    "ldoc -q -i --filter ldoc/filters.json " +
    KONG_PATH +
    "/kong/pdk";
  obj = childProcess.spawnSync(cmd, { shell: true });
  // ignore "unkwnown tag" errors
  errLog = obj.stderr.toString().replace(/.*unknown tag.*\n/g, "");
  if (errLog.length > 0) {
    return cb(errLog);
  }
  modules = JSON.parse(obj.stdout.toString());

  // 2.3 For each module, generate its docs in markdown
  for (let module of modules) {
    cmd =
      'LUA_PATH="$LUA_PATH;./?.lua" ' +
      "ldoc -q -c ldoc/config.ld " +
      module.file +
      " && " +
      "mv ./" +
      module.generated_name +
      ".md " +
      refDir +
      "/" +
      module.name +
      ".md";
    obj = childProcess.spawnSync(cmd, { shell: true });
    errLog = obj.stderr.toString();
    if (errLog.length > 0) {
      return cb(errLog);
    }
  }
  log("Re-generated PDK docs in " + refDir);

  // 3 Write pdk_info yaml file
  // 3.1 Obtain git sha-1 hash of the current git log
  cmd =
    "pushd " + KONG_PATH + " > /dev/null; git rev-parse HEAD; popd > /dev/null";
  obj = childProcess.spawnSync(cmd, { shell: true });
  errLog = obj.stderr.toString();
  if (errLog.length > 0) {
    return cb(errLog);
  }
  gitSha1 = obj.stdout.toString().trim();

  // 3.2 Write it into file
  confFilepath = "app/_data/pdk_info.yml";
  fs.writeFileSync(confFilepath, "sha1: " + gitSha1 + "\n");
  log("git SHA-1 (" + gitSha1 + ") written to " + confFilepath);
}

function admin_api_docs(cb) {
  var KONG_PATH, KONG_VERSION, cmd, obj, errLog;

  // 0 Obtain "env-var params"
  KONG_PATH = process.env.KONG_PATH;
  if (KONG_PATH === undefined) {
    return cb("No KONG_PATH environment variable set");
  }

  KONG_VERSION = process.env.KONG_VERSION;
  if (KONG_VERSION === undefined) {
    return cb("No KONG_VERSION environment variable set. Example: 0.14.x");
  }

  // 1 Generate admin-api.md
  cmd = "resty autodoc-admin-api/run.lua";
  obj = childProcess.spawnSync(cmd, { shell: true });
  errLog = obj.stderr.toString();
  if (errLog.length > 0) {
    return cb(errLog);
  }

  log("Re-generated Admin API docs for " + KONG_VERSION);
}

function cli_docs(cb) {
  var KONG_PATH, KONG_VERSION, cmd, obj, errLog;

  // 0 Obtain "env-var params"
  KONG_PATH = process.env.KONG_PATH;
  if (KONG_PATH === undefined) {
    return cb("No KONG_PATH environment variable set");
  }

  KONG_VERSION = process.env.KONG_VERSION;
  if (KONG_VERSION === undefined) {
    return cb("No KONG_VERSION environment variable set. Example: 1.0.x");
  }

  // 1 Generate cli.md
  cmd = "luajit autodoc-cli/run.lua";
  obj = childProcess.spawnSync(cmd, { shell: true });
  errLog = obj.stderr.toString();
  if (errLog.length > 0) {
    return cb(errLog);
  }

  log("Re-generated CLI docs for " + KONG_VERSION);
}

function conf_docs(cb) {
  var KONG_PATH, KONG_VERSION, cmd, obj, errLog;

  // 0 Obtain "env-var params"
  KONG_PATH = process.env.KONG_PATH;
  if (KONG_PATH === undefined) {
    return cb("No KONG_PATH environment variable set");
  }

  KONG_VERSION = process.env.KONG_VERSION;
  if (KONG_VERSION === undefined) {
    return cb("No KONG_VERSION environment variable set. Example: 1.0.x");
  }

  // Generate configuration.md
  cmd = "luajit autodoc-conf/run.lua";
  obj = childProcess.spawnSync(cmd, { shell: true });
  errLog = obj.stderr.toString();
  if (errLog.length > 0) {
    return cb(errLog);
  }

  log("Re-generated Conf docs for " + KONG_VERSION);
}

function nav_docs(cb) {
  var KONG_VERSION, cmd, obj, errLog;

  // 0 Obtain "env-var params"
  KONG_VERSION = process.env.KONG_VERSION;
  if (KONG_VERSION === undefined) {
    return cb("No KONG_VERSION environment variable set. Example: 1.0.x");
  }

  // 1 Generate docs_nav_X.Y.x.yml
  cmd = "luajit autodoc-nav/run.lua";
  obj = childProcess.spawnSync(cmd, { shell: true });
  errLog = obj.stderr.toString();
  if (errLog.length > 0) {
    return cb(errLog);
  }

  log("Re-generated navigation file for " + KONG_VERSION);
}

// Custom Tasks
function browser_sync(done) {
  browserSync.init({
    logPrefix: " ▶ ",
    minify: false,
    notify: false,
    server: "dist",
    open: false,
  });
  done();
}

var reload_browser = (done) => {
  browserSync.reload();
  done();
};

function clean() {
  ghPages.clean();
  return del(["dist", ".gh-pages"]);
}

function watch_files() {
  gulp.watch(sources.content, gulp.series(jekyll, html, reload_browser));
  gulp.watch(sources.styles, styles);
  gulp.watch(sources.images, gulp.series(images, reload_browser));
  gulp.watch(sources.js, gulp.series(js, reload_browser));
  gulp.watch(paths.assets + "css/hub.css", css);
}

function set_dev(cb) {
  dev = true;
  cb();
}

/*----------------------------------------*/

// Basic Tasks
gulp.task("js", gulp.series(set_dev, js));
gulp.task("js_min", js);
gulp.task("css", css);
gulp.task("styles", styles);
gulp.task("images", gulp.series(set_dev, images));
gulp.task("images_min", images);
gulp.task("fonts", fonts);
gulp.task("jekyll", jekyll);
gulp.task("html", html);

// Lua Tasks
gulp.task("pdk_docs", pdk_docs);
gulp.task("admin_api_docs", admin_api_docs);
gulp.task("cli_docs", cli_docs);
gulp.task("conf_docs", conf_docs);
gulp.task("nav_docs", nav_docs);

// Custom Tasks
gulp.task("browser_sync", browser_sync);
gulp.task("set_dev", set_dev);

// Call the tasks in the correct order
function build_site(steps, append) {
  steps = steps || [];
  append = append || [];

  // These are the steps that always run for every build
  // If set_dev is called, some of these methods behave differently
  steps = steps.concat([
    clean,
    gulp.parallel(js, images, fonts, css),
    jekyll,
    html,
    styles,
  ]);

  if (append.length) {
    steps = steps.concat(append);
  }

  return gulp.series.apply(null, steps);
}

gulp.task("default", build_site([set_dev], [browser_sync, watch_files]));
gulp.task("dev", build_site([set_dev], [browser_sync, watch_files]));
gulp.task("prod", build_site(null, [browser_sync, watch_files]));
gulp.task("build", build_site());
