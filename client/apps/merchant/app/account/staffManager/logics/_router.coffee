staffManagerRoute =
  template: 'staffManager'
  waitOnDependency: 'staffManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.staffManager, Apps.Merchant.staffManagerInit, 'staffManager')
      @next()
  data: -> {
    gridOptions: logics.staffManager.gridOptions
    roleSelectOptions: logics.staffManager.roleSelectOptions
    branchSelectOptions: logics.staffManager.branchSelectOptions
    warehouseSelectOptions: logics.staffManager.warehouseSelectOptions
  }

lemon.addRoute [staffManagerRoute], Apps.Merchant.RouterBase