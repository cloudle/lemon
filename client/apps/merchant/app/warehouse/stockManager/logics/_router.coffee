stockManagerRoute =
  template: 'stockManager',
  waitOnDependency: 'stockManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.stockManager, Apps.Merchant.stockManagerInit, 'stockManager')
      @next()
  data: ->
    logics.stockManager.reactiveRun()

    return {
      totalQualityProduct: logics.stockManager.totalQualityProduct() ? 0
      totalStockProduct  : logics.stockManager.totalStockProduct() ? 0
      totalProduct       : logics.stockManager.availableProducts?.count() ? 0

      gridOptions: logics.stockManager.gridOptions
    }

lemon.addRoute [stockManagerRoute], Apps.Merchant.RouterBase
