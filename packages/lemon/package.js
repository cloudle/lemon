Package.describe({
  summary: "System package for lemonEngine",
  version: "1.0.0",
  git: ""
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.1.1');

  api.addFiles([
    'core/templateHelpers.coffee'
  ], 'client');

  api.addFiles([
    'namespace.coffee',

    'core/core.coffee',
    'core/router.coffee',
    'core/dependency.coffee',
    'core/validation.coffee',
    'core/command.coffee',

    //Schema system
    'core/schema/model.coffee',
    'core/schema/core.coffee',
    'core/schema/built.in.coffee',

    //Component system
    'core/component/core.coffee',
    'core/component/widget.coffee',
    'core/component/app.coffee',

    //Database operations
    'system/seeds.coffee',
    'system/migrate.coffee',

    //System collections & model
    'system/schema/migration.coffee',
    'system/schema/system.coffee',
    'system/system.coffee',

    //Profiles, Roles & Permissions
    'system/schema/user.profile.coffee',
    'system/schema/role.coffee',
    'system/role.coffee',

    //Kaizen collections & model
    'system/schema/kaizen.coffee',
    'system/kaizen.coffee',

    //Messenger
    'messenger/schema/message.coffee',
    'messenger/messenger.coffee'
    ], ['client', 'server']);

  //api.addFiles([
  //  'lib/sky.coffee',
  //  'lib/menu.coffee',
  //  'lib/notification.coffee',
  //  'lib/template.coffee']
  //, ['client', 'server']);

  api.use(['coffeescript', 'underscore', 'aldeed:collection2'], ['client', 'server']);
  api.use(['jquery', 'templating'], 'client');
});