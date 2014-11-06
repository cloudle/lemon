formatWarehouseSelect = (item) -> "#{item.name}" if item

Apps.Merchant.staffManagerInit.push (scope) ->
  Session.set 'createStaffWarehouseSelection', Schema.warehouses.findOne(Session.get('myProfile').currentWarehouse)

  logics.staffManager.warehouseSelectOptions =
    query: (query) -> query.callback
      results: Schema.warehouses.find({merchant: Session.get('myProfile').currentMerchant}).fetch()
    initSelection: (element, callback) -> callback Session.get('createStaffWarehouseSelection')
    changeAction: (e) -> Session.set('createStaffWarehouseSelection', e.added)
    reactiveValueGetter: -> Session.get('createStaffWarehouseSelection')
    formatSelection: formatWarehouseSelect
    formatResult:    formatWarehouseSelect