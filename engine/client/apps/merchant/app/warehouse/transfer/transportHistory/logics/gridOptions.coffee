Apps.Merchant.transportHistoryInit.push (scope) ->
  logics.transportHistory.gridOptions =
    itemTemplate: 'transportHistoryThumbnail'
    reactiveSourceGetter: -> logics.transportHistory.availableTransports
    wrapperClasses: 'detail-grid row'
