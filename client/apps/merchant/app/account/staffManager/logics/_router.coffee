staffManagerRoute =
  template: 'staffManager',
  waitOn: -> lemon.dependencies.resolve('staffManager', Apps.MerchantSubscriber)
  data: -> {
    gridOptions: logics.staffManager.gridOptions
  }
_.extend(staffManagerRoute, Apps.Merchant.RouterBase)

lemon.addRoute [staffManagerRoute]