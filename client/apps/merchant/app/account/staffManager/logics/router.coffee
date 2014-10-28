staffManagerRoute =
  template: 'staffManager',
  waitOn: -> lemon.dependencies.resolve('staffManager')
  data: -> {
    gridOptions: logics.staffManager.gridOptions
  }
_.extend(staffManagerRoute, Merchant.merchantRouteBase)

lemon.addRoute [staffManagerRoute]