branchManagerRoute =
  template: 'branchManager',
  waitOnDependency: 'branchManager'
  onBeforeAction: -> if @ready() then Apps.setup(logics.branchManager, Apps.Merchant.branchManagerInit, 'branchManager')
  data: ->
    logics.branchManager.reactiveRun()

    return {
      allowCreate: logics.branchManager.allowCreate
      gridOptions: logics.branchManager.gridOptions
    }

lemon.addRoute [branchManagerRoute], Apps.Merchant.RouterBase
