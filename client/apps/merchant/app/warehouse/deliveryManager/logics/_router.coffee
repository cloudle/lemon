deliveryManagerRoute =
  template: 'deliveryManager',
  waitOnDependency: 'deliveryManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.deliveryManager, Apps.Merchant.deliveryManagerInit, 'deliveryManager')
  data: ->
    logics.deliveryManager.reactiveRun()

    return {
      gridOptions: logics.deliveryManager.gridOptions
    }

lemon.addRoute [deliveryManagerRoute], Apps.Merchant.RouterBase
