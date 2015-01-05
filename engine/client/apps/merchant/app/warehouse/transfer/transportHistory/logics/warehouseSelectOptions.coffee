formatWarehouseSearch = (item) -> "#{item.name}" if item

Apps.Merchant.transportHistoryInit.push (scope) ->
  scope.warehouseSelectOptions =
    query: (query) -> query.callback
      results: scope.availableWarehouses.fetch()
    initSelection: (element, callback) ->
      callback(Schema.warehouses.findOne(Session.get('mySession')?.currentTransportWarehouseSelection) ? 'skyReset')
    reactiveValueGetter: -> Session.get('mySession')?.currentTransportWarehouseSelection ? 'skyReset'
    changeAction: (e) ->
      scope.currentWarehouse = e.added
      Schema.userSessions.update Session.get('mySession')._id, $set:{currentTransportWarehouseSelection: e.added._id}

    minimumResultsForSearch: -1
    formatSelection: formatWarehouseSearch
    formatResult: formatWarehouseSearch
    placeholder: 'CHỌN CHI NHÁNH'


