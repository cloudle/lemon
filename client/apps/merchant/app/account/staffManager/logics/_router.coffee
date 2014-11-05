staffManagerRoute =
  template: 'staffManager'
  waitOnDependency: 'staffManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.customerManager, Apps.Merchant.customerManagerInit, 'customerManager')
      @next()
  data: -> {
    gridOptions: logics.staffManager.gridOptions
  }

lemon.addRoute [staffManagerRoute], Apps.Merchant.RouterBase