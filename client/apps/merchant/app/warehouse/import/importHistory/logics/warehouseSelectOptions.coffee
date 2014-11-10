formatWarehouseSearch = (item) -> "#{item.name}" if item

Apps.Merchant.importHistoryInit.push (scope) ->
  scope.warehouseSelectOptions =
    query: (query) -> query.callback
      results: scope.availableWarehouses.fetch()
    initSelection: (element, callback) -> callback(Session.get('currentImportWarehouse') ? 'skyReset')
    reactiveValueGetter: -> Session.get('currentImportWarehouse')?._id ? 'skyReset'
    changeAction: (e) -> scope.currentWarehouse = e.added; UserSession.set('currentImportWarehouse', e.added._id)
    minimumResultsForSearch: -1
    formatSelection: formatWarehouseSearch
    formatResult: formatWarehouseSearch
    placeholder: 'CHỌN CHI NHÁNH'


