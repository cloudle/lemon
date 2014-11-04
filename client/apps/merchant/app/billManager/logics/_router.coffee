billManagerRoute =
  template: 'billManager',
  waitOnDependency: 'billManager'
  onBeforeAction: -> if @ready() then Apps.setup(logics.billManager, Apps.Merchant.billManagerInit, 'billManager')
  data: ->
    logics.billManager.reactiveRun()

    return {
      gridOptions: logics.billManager.gridOptions
    }

lemon.addRoute [billManagerRoute], Apps.Merchant.RouterBase
