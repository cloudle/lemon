lemon.addRoute [
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('dep1')
  data: -> {

  }
]