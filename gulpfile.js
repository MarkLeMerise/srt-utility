'use strict';

var browserify = require('browserify'),
	gulp = require('gulp'),
	source = require('vinyl-source-stream'),
	log = require('fancy-log'),
	watchify = require('watchify');


var APP_ROOT = __dirname + '/src/web-player',
	BUILD_DIR = __dirname + '/web-player';


gulp.task('browserify', function() {
	var bundler = browserify({
		debug: true,
		entries: [APP_ROOT + '/scripts/app.coffee'],
		extensions: ['.coffee']
	});

	function rebundle() {
		return bundler
			.bundle()
			.pipe(source('app.js'))
			.on('error', log)
			.pipe(gulp.dest(BUILD_DIR + '/scripts'));
	}

	if (global.isWatching) {
		bundler = watchify(bundler);
		bundler.on('update', rebundle);
	}

	return rebundle();
});

gulp.task('html', function() {
	return gulp.src(APP_ROOT + '/index.html')
	.pipe(gulp.dest(BUILD_DIR));
});

gulp.task('styles', function() {
	return gulp.src(APP_ROOT + '/styles/*.css')
	.pipe(gulp.dest(BUILD_DIR + '/styles'));
});

gulp.task('clean', function (done) {
	require('del')(BUILD_DIR, done);
});

gulp.task('watch', function() {
	global.isWatching = true;

	gulp.watch(APP_ROOT + '/styles/*.css', ['styles']);
	gulp.watch(APP_ROOT + '/*.html', ['html']);
});

gulp.task('default', ['watch', 'build']);

gulp.task('build', ['html', 'browserify', 'styles']);
