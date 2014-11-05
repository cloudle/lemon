formatMerchantSearch = (item) -> "#{item.name}" if item

Apps.Merchant.inventoryManagerInit.push (scope) ->
  logics.inventoryManager.merchantSelectOptions =
    query: (query) -> query.callback
      results: _.filter logics.inventoryManager.availableMerchants.fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
    initSelection: (element, callback) ->
      callback(Schema.merchants.findOne(Session.get('mySession').currentMerchant) ? 'skyReset')
    formatSelection: formatMerchantSearch
    formatResult: formatMerchantSearch
    placeholder: 'CHỌN CHI NHÁNH'
    minimumResultsForSearch: -1
    changeAction: (e) ->
      UserSession.set('currentMerchant', e.added._id)
      logics.inventoryManager.availableWarehouses = Schema.warehouses.find({merchant: e.added._id})
      UserSession.set('currentWarehouse', Schema.warehouses.findOne({merchant: e.added._id, isRoot: true})._id)
    reactiveValueGetter: -> Session.get('mySession').currentMerchant ? 'skyReset'
