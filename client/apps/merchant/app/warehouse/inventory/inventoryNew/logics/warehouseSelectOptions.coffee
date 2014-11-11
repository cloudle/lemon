formatWarehouseSearch = (item) -> "#{item.name}" if item

Apps.Merchant.inventoryManagerInit.push (scope) ->
  logics.inventoryManager.warehouseSelectOptions =
    query: (query) -> query.callback
      results: logics.inventoryManager.availableWarehouses.fetch()
    initSelection: (element, callback) ->
      callback(Schema.warehouses.findOne(Session.get('mySession').currentInventoryWarehouseSelection) ? 'skyReset')
    reactiveValueGetter: -> Session.get('mySession').currentInventoryWarehouseSelection ? 'skyReset'
    changeAction: (e) ->
      scope.currentWarehouse = e.added
      Schema.userSessions.update Session.get('mySession')._id, $set:{currentInventoryWarehouseSelection: e.added._id}

    minimumResultsForSearch: -1
    formatSelection: formatWarehouseSearch
    formatResult: formatWarehouseSearch
    placeholder: 'CHỌN CHI NHÁNH'


