Package.describe({
  summary: "System package for lemonEngine",
  version: "1.0.0",
  git: ""
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.1.1');

  api.addFiles([
    'lib/3rds/animate.css',
    'lib/3rds/moment.js',
    'lib/3rds/switchery.css',
    'lib/3rds/switchery.js'
    ] , 'client');

  api.addFiles([
    'core/lemon.coffee',
    'component/core.coffee',
    'component/widget.coffee',
    'component/app.coffee'
    ] , 'client');

  api.addFiles([
    'lib/3rds/accounting.js']
  , ['client', 'server']);

  //api.addFiles([
  //  'lib/sky.coffee',
  //  'lib/menu.coffee',
  //  'lib/notification.coffee',
  //  'lib/template.coffee']
  //, ['client', 'server']);

  api.use(['coffeescript', 'underscore'], ['client', 'server']);
  api.use(['jquery'], 'client');
});