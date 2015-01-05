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
      newTransaction          : Session.get('createNewTransaction')
      gridOptions             : logics.transactionManager.gridOptions
      totalCashOptions        : logics.transactionManager.totalCashOptions
      depositCashOptions      : logics.transactionManager.depositCashOptions
      customerSelectOptions   : logics.transactionManager.customerSelectOptions

      currentTransaction        : Session.get('currentTransaction')
      currentTransactionDetail  : logics.transactionManager.transactionDetails


    }

lemon.addRoute [transactionManagerRoute], Apps.Merchant.RouterBase