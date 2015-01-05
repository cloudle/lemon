formatWarehouseSearch = (item) -> "#{item.name}" if item

Apps.Merchant.inventoryHistoryInit.push (scope) ->
  scope.warehouseSelectOptions =
    query: (query) -> query.callback
      results: scope.availableWarehouses.fetch()
    initSelection: (element, callback) ->
      callback(Schema.warehouses.findOne(Session.get('mySession')?.currentInventoryWarehouseSelection) ? 'skyReset')
    reactiveValueGetter: -> Session.get('mySession')?.currentInventoryWarehouseSelection ? 'skyReset'
    changeAction: (e) ->
      scope.currentWarehouse = e.added
      Schema.userSessions.update Session.get('mySession')._id, $set:{currentInventoryWarehouseSelection: e.added._id}

    minimumResultsForSearch: -1
    formatSelection: formatWarehouseSearch
    formatResult: formatWarehouseSearch
    placeholder: 'CHỌN CHI NHÁNH'


