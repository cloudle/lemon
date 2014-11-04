customerManagerRoute =
  template: 'customerManager',
  waitOnDependency: 'customerManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.customerManager, Apps.Merchant.customerManagerInit, 'customerManager')
  data: ->
    logics.customerManager.reactiveRun()

    return {
      gridOptions: logics.customerManager.gridOptions
      allowCreate: logics.customerManager.allowCreate
    }

lemon.addRoute [customerManagerRoute], Apps.Merchant.RouterBase
