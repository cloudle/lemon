accountingManagerRoute =
  template: 'accountingManager',
  waitOnDependency: 'accountingManager'
  onBeforeAction: -> if @ready() then Apps.setup(logics.accountingManager, Apps.Merchant.accountingManagerInit, 'accountingManager')
  data: ->
    logics.accountingManager.reactiveRun()
    return {
      gridOptions: logics.accountingManager.gridOptions
    }

lemon.addRoute [accountingManagerRoute], Apps.Merchant.RouterBase
