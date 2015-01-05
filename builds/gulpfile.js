var gulp = require('gulp'),
    concat = require('gulp-concat');

gulp.task('default', function(){
    gulp.src(['./lib/**/*.coffee'])
        .pipe(concat('core.coffee'))
        .pipe(gulp.dest('../engine/client/lib/core/'))
});