inventoryManagerRoute =
  template: 'inventory',
  waitOnDependency: 'inventoryManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.inventoryManager, Apps.Merchant.inventoryManagerInit, 'inventory')
      @next()
  data: ->
    logics.inventoryManager.reactiveRun()

    return {
    }

lemon.addRoute [inventoryManagerRoute], Apps.Merchant.RouterBase, Apps.MerchantSubscriber
