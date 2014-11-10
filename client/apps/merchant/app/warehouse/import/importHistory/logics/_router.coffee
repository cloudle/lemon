importHistoryRoute =
  template: 'importHistory',
  waitOnDependency: 'importHistory'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.importHistory, Apps.Merchant.importHistoryInit, 'importHistory')
      @next()
  data: ->
    Apps.setup(logics.importHistory, Apps.Merchant.importHistoryReactiveRun)
    return {
      gridOptions           : logics.importHistory.gridOptions
      branchSelectOptions   : logics.importHistory.branchSelectOptions
      warehouseSelectOptions: logics.importHistory.warehouseSelectOptions

      currentImport       : Session.get('currentImportHistory')
      currentImportDetail : logics.importHistory.currentImportHistoryDetail
    }

lemon.addRoute [importHistoryRoute], Apps.Merchant.RouterBase
