billManagerRoute =
  template: 'billManager',
  waitOnDependency: 'billManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.billManager, Apps.Merchant.billManagerInit, 'billManager')
      @next()
  data: ->
    logics.billManager.reactiveRun()

    return {
      gridOptions: logics.billManager.gridOptions
      currentSale: Session.get('currentBillManagerSale')
      currentSaleDetails: logics.billManager.currentSaleDetails
    }

lemon.addRoute [billManagerRoute], Apps.Merchant.RouterBase