staffManagerRoute =
  template: 'staffManager',
  waitOn: -> lemon.dependencies.resolve('staffManager', Apps.MerchantSubscriber)
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.customerManager, Apps.Merchant.customerManagerInit, 'customerManager')
      @next()
  data: -> {
    gridOptions: logics.staffManager.gridOptions
  }

lemon.addRoute [staffManagerRoute], Apps.Merchant.RouterBase