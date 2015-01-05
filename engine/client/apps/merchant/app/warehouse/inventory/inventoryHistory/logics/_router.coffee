inventoryHistoryRoute =
  template: 'inventoryHistory',
  waitOnDependency: 'inventoryHistory'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.inventoryHistory, Apps.Merchant.inventoryHistoryInit, 'inventoryHistory')
      @next()
  data: ->
    Apps.setup(logics.inventoryHistory, Apps.Merchant.inventoryHistoryReactiveRun)
    return {
      gridOptions                 : logics.inventoryHistory.gridOptions
      branchSelectOptions         : logics.inventoryHistory.branchSelectOptions
      warehouseSelectOptions      : logics.inventoryHistory.warehouseSelectOptions

      currentInventory            : Session.get('currentInventoryHistory')
      currentInventoryDetails     : logics.inventoryHistory.currentInventoryDetailHistory
      currentInventoryProductLost : logics.inventoryHistory.currentInventoryProductLostHistory
    }

lemon.addRoute [inventoryHistoryRoute], Apps.Merchant.RouterBase
