transactionManagerRoute =
  template: 'transactionManager',
  waitOnDependency: 'transactionManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.transactionManager, Apps.Merchant.transactionManagerInit, 'transactionManager')
      @next()
  data: ->
    Apps.setup(logics.transactionManager, Apps.Merchant.transactionManagerReactiveRun)
    return {
      gridOptions             : logics.transactionManager.gridOptions
      debitCashOptions        : logics.transactionManager.debitCashOptions
      customerSelectOptions   : logics.transactionManager.customerSelectOptions

      currentTransaction        : Session.get('currentTransaction')
      currentTransactionDetail  : logics.transactionManager.transactionDetails


    }

lemon.addRoute [transactionManagerRoute], Apps.Merchant.RouterBase