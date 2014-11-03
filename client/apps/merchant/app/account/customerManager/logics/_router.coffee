customerManagerRoute =
  template: 'customerManager',
  waitOn: -> lemon.dependencies.resolve('customerManager', Apps.MerchantSubscriber)
  data: -> {
    gridOptions: logics.customerManager.gridOptions
  }

lemon.addRoute [customerManagerRoute], Apps.Merchant.RouterBase