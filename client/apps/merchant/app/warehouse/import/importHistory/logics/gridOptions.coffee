Apps.Merchant.importHistoryInit.push (scope) ->
  scope.gridOptions =
    itemTemplate: 'importHistoryThumbnail'
    reactiveSourceGetter: -> scope.importHistorys
    wrapperClasses: 'detail-grid row'
