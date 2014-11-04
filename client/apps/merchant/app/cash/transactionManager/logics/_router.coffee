transactionManagerRoute =
  template: 'transactionManager',
  waitOnDependency: 'transactionManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.transactionManager, Apps.Merchant.transactionManagerInit, 'transactionManager')
      @next()
  data: ->
    logics.transactionManager.reactiveRun()

    return {
      gridOptions: logics.transactionManager.gridOptions
    }

lemon.addRoute [transactionManagerRoute], Apps.Merchant.RouterBase