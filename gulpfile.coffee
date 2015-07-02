gulp = require "gulp"
jade = require "gulp-jade"
coffee = require "gulp-coffee"
stylus = require "gulp-stylus"
nib = require "nib"
connect = require "gulp-connect"
rename = require "gulp-rename"
clean = require "gulp-clean"
plumber = require "gulp-plumber"
uglify = require "gulp-uglify"
browserify = require "gulp-browserify"
sequence = require "run-sequence"

gulp.task "connect", ->
	connect.server
		port: 3000
		root: "public"
		livereload: on

gulp.task "templates", ->
	gulp.src [ "src/templates/*.jade", "!src/templates/_*.jade" ]
		.pipe do plumber
		.pipe do jade
		.pipe gulp.dest "public"
		.pipe do connect.reload

gulp.task "scripts", ->
	gulp.src "src/scripts/main.coffee", read: off
		.pipe do plumber
		.pipe browserify
			transform: ["coffeeify"]
			extensions: [".coffee"]
			shim:
				jquery:
					path: "bower_components/jquery/dist/jquery.min.js"
					exports: "$"
		.pipe do uglify
		.pipe rename "app.js"
		.pipe gulp.dest "public/js"
		.pipe do connect.reload

gulp.task "styles", ->
	gulp.src "src/styles/*.styl"
		.pipe do plumber
		.pipe stylus
			compress: on
			use: do nib
			import: 'nib'
		.pipe rename "app.css"
		.pipe gulp.dest "public/css"
		.pipe do connect.reload

gulp.task "clean", ->
	return gulp.src "public"
		.pipe do clean

gulp.task "default", (cb) ->
	sequence "clean","templates","scripts","styles","connect", cb

	gulp.watch "src/templates/*.jade", ["templates"]
	gulp.watch "src/scripts/*.coffee", ["scripts"]
	gulp.watch "src/styles/*.styl", ["styles"]


