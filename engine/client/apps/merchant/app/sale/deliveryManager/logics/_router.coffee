deliveryManagerRoute =
  template: 'deliveryManager',
  waitOnDependency: 'deliveryManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.deliveryManager, Apps.Merchant.deliveryManagerInit, 'deliveryManager')
      @next()
  data: ->
    return {
      waitingGridOptions: logics.deliveryManager.waitingGridOptions
      deliveringGridOptions: logics.deliveryManager.deliveringGridOptions
      doneGridOptions: logics.deliveryManager.doneGridOptions
    }

lemon.addRoute [deliveryManagerRoute], Apps.Merchant.RouterBase