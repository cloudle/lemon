staffManagerRoute =
  template: 'staffManager'
  waitOnDependency: 'staffManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.staffManager, Apps.Merchant.staffManagerInit, 'staffManager')
      @next()
  data: ->
    Apps.setup(logics.staffManager, Apps.Merchant.staffManagerReactiveRun)
    return {
      gridOptions: logics.staffManager.gridOptions
      roleSelectOptions: logics.staffManager.roleSelectOptions
      branchSelectOptions: logics.staffManager.branchSelectOptions
      warehouseSelectOptions: logics.staffManager.warehouseSelectOptions
    }

lemon.addRoute [staffManagerRoute], Apps.Merchant.RouterBase