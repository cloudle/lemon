staffManagerRoute =
  template: 'staffManager',
  waitOn: -> lemon.dependencies.resolve('staffManager', Apps.MerchantSubscriber)
  onBeforeAction: ->
    Apps.setup(logics.customerManager, Apps.Merchant.customerManagerInit, 'customerManager') if @ready()
  data: -> {
    gridOptions: logics.staffManager.gridOptions
  }

lemon.addRoute [staffManagerRoute], Apps.Merchant.RouterBase