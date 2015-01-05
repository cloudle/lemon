Apps.Merchant.warehouseManagerInit.push (scope) ->
  logics.warehouseManager.gridOptions =
    itemTemplate: 'warehouseThumbnail'
    reactiveSourceGetter: -> logics.warehouseManager.availableWarehouses
    wrapperClasses: 'detail-grid row'