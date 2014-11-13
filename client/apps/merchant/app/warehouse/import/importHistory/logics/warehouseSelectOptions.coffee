formatWarehouseSearch = (item) -> "#{item.name}" if item

Apps.Merchant.importHistoryInit.push (scope) ->
  scope.warehouseSelectOptions =
    query: (query) -> query.callback
      results: scope.availableWarehouses.fetch()
    initSelection: (element, callback) ->
      callback(Schema.warehouses.findOne(Session.get('mySession')?.currentImportWarehouse) ? 'skyReset')
    reactiveValueGetter: -> Session.get('mySession')?.currentImportWarehouse ? 'skyReset'
    changeAction: (e) ->
      scope.currentWarehouse = e.added
      Schema.userSessions.update Session.get('mySession')._id, $set:{currentImportWarehouse: e.added._id}

    minimumResultsForSearch: -1
    formatSelection: formatWarehouseSearch
    formatResult: formatWarehouseSearch
    placeholder: 'CHỌN CHI NHÁNH'


