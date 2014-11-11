lemon.addRoute [
  template: 'home', path: '/', layoutTemplate: 'homeLayout', waitOnDependency: 'home'
,
  path: '/merchantWizard', layoutTemplate: 'subHomeLayout', waitOnDependency: 'merchantPurchase'
]