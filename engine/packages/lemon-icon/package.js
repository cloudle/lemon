Package.describe({
  summary: "Icon package for lemonEngine",
  version: "1.0.0",
  git: ""
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.1.1');

  api.addFiles([
    'lib/font/lemon.eot',
    'lib/font/lemon.svg',
    'lib/font/lemon.ttf',
    'lib/font/lemon.woff',
    'lib/css/lemon-embedded.css'
    //'lib/lemon.overrides.css'
    ], 'client');
});