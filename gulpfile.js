var gulp = require('gulp');
var path = require('path')
var del = require('del');
var watch = require('gulp-watch');
var gutil = require('gulp-util');
var stylus = require('gulp-stylus');
var changed = require('gulp-changed');
var notify = require("gulp-notify");
var nib = require('nib');
var express = require('express');
var imagemin = require('gulp-imagemin');

var webpack = require('webpack');
var webpackConfig = require('./webpack.config.js')

// base dir for build
var dest = "./public/build";

var config = {
    stylus: {
        files: './css/**/*',
        src: "./css/main.styl",
        out: 'main.css',
        dest: dest
    },
    html: {
        src: "./public/index.html",
        dest: dest
    },
    clean: {
        src: dest + '/**/*',
        dest: dest + '/'
    },
    images: {
        src: './public/assets/**/*',
        dest: dest + '/assets'
    },
    server: {
        dir: dest,
        port: 3333
    }
}

// error handing function, pass to on 'error'
var handleErrors = function() {
  var args = Array.prototype.slice.call(arguments);

  notify.onError({
    title: "Compile Error",
    message: "<%= error.message %>"
  }).apply(this, args);

  this.emit('end'); // Keep gulp from hanging on this task
};

// remove the build files
gulp.task('clean', function () {
    del([dest])
});

// copy / minify images
gulp.task('images', function() {
  return gulp.src(config.images.src)
    .pipe(changed(config.images.dest))
    .pipe(imagemin())
    .pipe(gulp.dest(config.images.dest));
});

// copy html to build dir
gulp.task('html', function() {
  return gulp.src(config.html.src)
    .on('error', handleErrors)
    .pipe(gulp.dest(config.html.dest));
});

// compile stylus and move to build dir
gulp.task('stylus', function() {
  gulp.src(config.stylus.src)
    // .pipe(changed(config.stylus.dest))
    .pipe(stylus({use: nib(), 'include css': true, errors: true}))
    .on('error', handleErrors)
    .pipe(gulp.dest(config.stylus.dest));
});

// watch for changes during development, build once first
gulp.task('watch', ['stylus', 'html', 'images', 'webpack'], function() {
    gulp.watch(config.stylus.files, ['stylus']);
    gulp.watch(config.html.src, ['html']);
    gulp.watch(config.images.src, ['images']);
});

// start a dev server
gulp.task('serve', function(){
    createServer(config.server.port);
});

// start webpack
gulp.task('webpack', function(callback){
    execWebpack(webpackConfig);
    callback();
})

var execWebpack = function(config){
    webpack((config), function(err, stats) {
        if (err) new gutil.PluginError("execWebpack", err);
        gutil.log(stats.toString({colors: true}));
    });
}

var createServer = function(port) {
    var app = express()
    app.use(express.static(path.resolve(dest)))
    app.listen(port, function(){
        gutil.log("Server started on ", port);
    })
}

gulp.task('default', ['serve', 'watch']);
