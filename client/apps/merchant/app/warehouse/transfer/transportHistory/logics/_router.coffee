transportHistoryRoute =
  template: 'transportHistory',
  waitOnDependency: 'transportHistory'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.transportHistory, Apps.Merchant.transportHistoryInit, 'transportHistory')
      @next()
  data: ->
    Apps.setup(logics.transportHistory, Apps.Merchant.transportHistoryReactiveRun)
    return {
      gridOptions                 : logics.transportHistory.gridOptions
      branchSelectOptions         : logics.transportHistory.branchSelectOptions
      warehouseSelectOptions      : logics.transportHistory.warehouseSelectOptions

      currentTransport            : Session.get('currentTransportHistory')
      currentTransportDetails     : logics.transportHistory.currentTransportDetailHistory
    }

lemon.addRoute [transportHistoryRoute], Apps.Merchant.RouterBase
