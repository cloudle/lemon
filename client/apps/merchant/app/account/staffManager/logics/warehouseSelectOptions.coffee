formatWarehouseSelect = (item) -> "#{item.name}" if item

Apps.Merchant.staffManagerInit.push (scope) ->
  scope.warehouseSelectOptions =
    query: (query) -> query.callback
      results: scope.availableWarehouses.fetch()
    initSelection: (element, callback) ->
      callback(Schema.warehouses.findOne(Session.get('mySession').createStaffWarehouseSelection) ? 'skyReset')
    changeAction: (e) ->  UserSession.set('createStaffWarehouseSelection', e.added._id)
    reactiveValueGetter: -> Session.get('mySession').createStaffWarehouseSelection ? 'skyReset'
    minimumResultsForSearch: -1
    formatSelection: formatWarehouseSelect
    formatResult:    formatWarehouseSelect