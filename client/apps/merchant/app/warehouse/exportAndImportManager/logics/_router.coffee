exportAndImportManagerRoute =
  template: 'exportAndImportManager',
  waitOnDependency: 'billManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.exportAndImportManager, Apps.Merchant.exportAndImportManagerInit, 'exportAndImportManager')
  data: ->
    logics.exportAndImportManager.reactiveRun()

    return {
      gridOptions: logics.exportAndImportManager.gridOptions
    }

lemon.addRoute [exportAndImportManagerRoute], Apps.Merchant.RouterBase
