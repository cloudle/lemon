Router.map ->
  @route 'home', { path: '/', layoutTemplate: 'homeLayout' }
  @route 'merchantWizard', { path: '/merchantWizard', layoutTemplate: 'subHomeLayout' }