Package.describe({
  summary: "System package for lemonEngine",
  version: "1.0.0",
  git: ""
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.1.1');

  //Client Only - third party libraries
  api.addFiles([
    '3rds/animate.css',
    '3rds/moment.js',
    '3rds/switchery.css',
    '3rds/switchery.js'
    ], 'client');

  //Global - Third party libraries
  api.addFiles([
    '3rds/accounting.js'
  ], ['client', 'server']);

  //Core libs
  api.addFiles([
    'namespace.coffee',

    //Schema system
    'core/schema/model.coffee',
    'core/schema/core.coffee',
    'core/schema/built.in.coffee',

    //Component system
    'core/component/core.coffee',
    'core/component/widget.coffee',
    'core/component/app.coffee',

    //Database operations
    'db/seeds.coffee',
    'db/migrate.coffee',

    //System collections & model
    'system/schema/migration.coffee',
    'system/schema/system.coffee',
    'system/system.coffee',

    //Kaizen collections & model
    'kaizen/schema/kaizen.coffee',
    'kaizen/kaizen.coffee'
    ], ['client', 'server']);

  //api.addFiles([
  //  'lib/sky.coffee',
  //  'lib/menu.coffee',
  //  'lib/notification.coffee',
  //  'lib/template.coffee']
  //, ['client', 'server']);

  api.use(['coffeescript', 'underscore', 'aldeed:collection2'], ['client', 'server']);
  api.use(['jquery'], 'client');
});