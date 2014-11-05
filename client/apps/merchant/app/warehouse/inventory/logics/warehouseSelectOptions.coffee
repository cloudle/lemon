formatWarehouseSearch = (item) -> "#{item.name}" if item

Apps.Merchant.inventoryManagerInit.push (scope) ->
  logics.inventoryManager.warehouseSelectOptions =
    query: (query) -> query.callback
      results: _.filter logics.inventoryManager.availableWarehouses.fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
    initSelection: (element, callback) ->
      callback(Schema.warehouses.findOne(Session.get('mySession').currentWarehouse) ? 'skyReset')
    formatSelection: formatWarehouseSearch
    formatResult: formatWarehouseSearch
    placeholder: 'CHỌN CHI NHÁNH'
    minimumResultsForSearch: -1
    changeAction: (e) ->
      UserSession.set('currentWarehouse', e.added._id)
      logics.inventoryManager.currentWarehouse = Schema.warehouses.findOne(e.added._id)
    reactiveValueGetter: -> Session.get('mySession').currentWarehouse ? 'skyReset'
