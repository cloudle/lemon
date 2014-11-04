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
      saleSelectOptions: logics.returns.saleSelectOptions
#      returnProductSelectOptions:
#      returnQualityOptions:
#
#      discountCashOptions:
#      discountPercentOptions:

#      gridOptions: logics.returns.gridOptions
    }

lemon.addRoute [returnsRoute], Apps.Merchant.RouterBase
