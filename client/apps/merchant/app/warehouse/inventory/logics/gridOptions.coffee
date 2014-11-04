Apps.Merchant.inventoryManagerInit.push (scope) ->
  logics.inventoryManager.gridOptions =
    itemTemplate: 'inventoryProductThumbnail'
    reactiveSourceGetter: -> logics.inventoryManager.availableDetails
    wrapperClasses: 'detail-grid row'