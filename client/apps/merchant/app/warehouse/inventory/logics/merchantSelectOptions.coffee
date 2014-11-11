formatMerchantSearch = (item) -> "#{item.name}" if item

Apps.Merchant.inventoryManagerInit.push (scope) ->
  logics.inventoryManager.merchantSelectOptions =
    query: (query) -> query.callback
      results: scope.availableMerchants.fetch()
    initSelection: (element, callback) ->  callback(Schema.merchants.findOne(Session.get('mySession').currentMerchant) ? 'skyReset')
    reactiveValueGetter: -> Session.get('mySession').currentMerchant ? 'skyReset'
    changeAction: (e) ->
      UserSession.set('currentMerchant', e.added._id)
      scope.availableWarehouses = Schema.warehouses.find({merchant: e.added._id})
      UserSession.set('currentWarehouse', Schema.warehouses.findOne({merchant: e.added._id, isRoot: true})._id)
    formatSelection: formatMerchantSearch
    formatResult: formatMerchantSearch
    placeholder: 'CHỌN CHI NHÁNH'
    minimumResultsForSearch: -1

