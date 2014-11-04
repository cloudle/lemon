branchManagerRoute =
  template: 'branchManager',
  waitOnDependency: 'branchManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.branchManager, Apps.Merchant.branchManagerInit, 'branchManager')
      @next()
  data: ->
    logics.branchManager.reactiveRun()

    return {
      allowCreate: logics.branchManager.allowCreate
      gridOptions: logics.branchManager.gridOptions
    }

lemon.addRoute [branchManagerRoute], Apps.Merchant.RouterBase
