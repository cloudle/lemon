Apps.Merchant.inventoryHistoryReactiveRun.push (scope) ->
  if scope.currentWarehouse
    scope.availableInventories = Schema.inventories.find({warehouse: scope.currentWarehouse._id}, {sort: {'version.createdAt': -1}})

Apps.Merchant.inventoryHistoryInit.push (scope) ->
  logics.inventoryHistory.gridOptions =
    itemTemplate: 'inventoryHistoryThumbnail'
    reactiveSourceGetter: -> logics.inventoryHistory.availableInventories
    wrapperClasses: 'detail-grid row'
