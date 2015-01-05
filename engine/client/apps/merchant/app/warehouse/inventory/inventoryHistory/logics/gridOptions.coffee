Apps.Merchant.inventoryHistoryInit.push (scope) ->
  logics.inventoryHistory.gridOptions =
    itemTemplate: 'inventoryHistoryThumbnail'
    reactiveSourceGetter: -> logics.inventoryHistory.availableInventories
    wrapperClasses: 'detail-grid row'
