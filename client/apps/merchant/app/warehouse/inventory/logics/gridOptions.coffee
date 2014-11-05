Apps.Merchant.inventoryManagerInit.push (scope) ->
  logics.inventoryManager.gridOptions =
    itemTemplate: 'inventoryProductThumbnail'
    reactiveSourceGetter: -> logics.inventoryManager.inventoryDetails
    wrapperClasses: 'detail-grid row'