returnsRoute =
  template: 'returns',
  waitOnDependency: 'returnManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.returns, Apps.Merchant.returnsInit, 'returns')
      @next()
  data: ->
    logics.returns.reactiveRun()

    return {
      currentReturn         : logics.returns.currentReturn
      saleSelectOptions     : logics.returns.saleSelectOptions
      productSelectOptions  : logics.returns.productSelectOptions
      returnQualityOptions  : logics.returns.returnQualityOptions
      discountCashOptions   : logics.returns.discountCashOptions
      discountPercentOptions: logics.returns.discountPercentOptions

      gridOptions: logics.returns.gridOptions
    }

lemon.addRoute [returnsRoute], Apps.Merchant.RouterBase
