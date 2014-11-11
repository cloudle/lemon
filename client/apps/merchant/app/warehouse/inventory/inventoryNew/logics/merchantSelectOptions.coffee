formatMerchantSearch = (item) -> "#{item.name}" if item

Apps.Merchant.inventoryManagerInit.push (scope) ->
  logics.inventoryManager.merchantSelectOptions =
    query: (query) -> query.callback
      results: scope.availableMerchants.fetch()
    initSelection: (element, callback) ->  callback(Schema.merchants.findOne(Session.get('mySession').currentInventoryBranchSelection) ? 'skyReset')
    reactiveValueGetter: -> Session.get('mySession').currentInventoryBranchSelection ? 'skyReset'
    changeAction: (e) ->
      UserSession.set('currentInventoryBranchSelection', e.added._id)
      scope.availableWarehouses = Schema.warehouses.find({merchant: e.added._id})
      UserSession.set('currentInventoryWarehouseSelection', Schema.warehouses.findOne({merchant: e.added._id, isRoot: true})._id)

    minimumResultsForSearch: -1
    formatSelection: formatMerchantSearch
    formatResult: formatMerchantSearch
    placeholder: 'CHỌN CHI NHÁNH'