warehouseManagerRoute =
  template: 'warehouseManager',
  waitOnDependency: 'warehouseManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.warehouseManager, Apps.Merchant.warehouseManagerInit, 'warehouseManager')
      @next()
  data: ->
    logics.warehouseManager.reactiveRun()

    return {
      allowCreate: logics.warehouseManager.allowCreate
      gridOptions: logics.warehouseManager.gridOptions
    }

lemon.addRoute [warehouseManagerRoute], Apps.Merchant.RouterBase
