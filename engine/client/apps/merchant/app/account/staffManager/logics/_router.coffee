scope = logics.staffManager

lemon.addRoute
  template: 'staffManager'
  waitOnDependency: 'staffManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.staffManagerInit, 'staffManager')
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.staffManagerReactiveRun)
    return {
      gridOptions: scope.gridOptions
      roleSelectOptions: scope.roleSelectOptions
      branchSelectOptions: scope.branchSelectOptions
      warehouseSelectOptions: scope.warehouseSelectOptions
    }
, Apps.Merchant.RouterBase