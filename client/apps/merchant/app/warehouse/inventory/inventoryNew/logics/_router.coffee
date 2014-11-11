inventoryManagerRoute =
  template: 'inventory',
  waitOnDependency: 'inventoryManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.inventoryManager, Apps.Merchant.inventoryManagerInit, 'inventory')
      @next()
  data: ->
    Apps.setup(logics.inventoryManager, Apps.Merchant.inventoryReactiveRun)

    return {
      show: true
      allowCreate     : logics.inventoryManager.allowCreate
      showCreate      : logics.inventoryManager.showCreate
      showDestroy     : logics.inventoryManager.showDestroy
      showDescription : logics.inventoryManager.showDescription
      showSubmit      : logics.inventoryManager.showSubmit

      gridOptions     : logics.inventoryManager.gridOptions
      currentInventory: logics.inventoryManager.currentInventory

      merchantSelectOptions: logics.inventoryManager.merchantSelectOptions
      warehouseSelectOptions: logics.inventoryManager.warehouseSelectOptions
    }

lemon.addRoute [inventoryManagerRoute], Apps.Merchant.RouterBase
