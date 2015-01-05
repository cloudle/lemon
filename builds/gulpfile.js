var gulp = require('gulp'),
    concat = require('gulp-concat');

gulp.task('default', function(){
    gulp.src(['./lib/core.coffee', './lib/helpers/*.coffee'])
        .pipe(concat('core.coffee'))
        .pipe(gulp.dest('../engine/lib/importants/stack1/stack2/core'))
});