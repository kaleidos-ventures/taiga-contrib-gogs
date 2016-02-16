var gulp = require('gulp');
var $ = require('gulp-load-plugins')();
var merge = require('merge-stream');

var paths = {
    jade: 'partials/*.jade',
    coffee: 'coffee/*.coffee',
    dist: 'dist/'
};

gulp.task('copy-config', function() {
    return gulp.src('gogs.json')
        .pipe(gulp.dest(paths.dist));
});

gulp.task('compile', function() {
    var jade = gulp.src(paths.jade)
        .pipe($.plumber())
        .pipe($.cached('jade'))
        .pipe($.jade({pretty: true}))
        .pipe($.angularTemplatecache({
            transformUrl: function(url) {
                return '/plugins/gogs/' + url;
            }
        }))
        .pipe($.remember('jade'));

    var coffee = gulp.src(paths.coffee)
        .pipe($.plumber())
        .pipe($.cached('coffee'))
        .pipe($.coffee())
        .pipe($.remember('coffee'));

    return merge(jade, coffee)
        .pipe($.concat('gogs.js'))
        .pipe($.uglify({mangle:false, preserveComments: false}))
        .pipe(gulp.dest(paths.dist));
});

gulp.task('watch', function() {
    gulp.watch([paths.jade, paths.coffee], ['compile']);
});

gulp.task('default', ['copy-config', 'compile', 'watch']);

gulp.task('build', ['copy-config', 'compile', ]);
