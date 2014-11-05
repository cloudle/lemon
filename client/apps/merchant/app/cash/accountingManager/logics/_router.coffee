accountingManagerRoute =
  template: 'accountingManager',
  waitOnDependency: 'accountingManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.accountingManager, Apps.Merchant.accountingManagerInit, 'accountingManager')
      @next()
  data: ->
    logics.accountingManager.reactiveRun()
    return {
      gridOptions: logics.accountingManager.gridOptions
    }

lemon.addRoute [accountingManagerRoute], Apps.Merchant.RouterBase
