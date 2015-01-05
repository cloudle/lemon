formatMerchantSearch = (item) -> "#{item.name}" if item

Apps.Merchant.importHistoryInit.push (scope) ->
  scope.branchSelectOptions =
    query: (query) -> query.callback
      results: scope.availableMerchants.fetch()
    initSelection: (element, callback) ->
      callback(Schema.merchants.findOne(Session.get('mySession')?.currentImportMerchant) ? 'skyReset')
    reactiveValueGetter: -> Session.get('mySession')?.currentImportMerchant ? 'skyReset'
    changeAction: (e) ->
      option =
        currentImportMerchant : e.added._id
        currentImportWarehouse: Schema.warehouses.findOne({merchant: e.added._id, isRoot: true})._id
      Schema.userSessions.update Session.get('mySession')._id, $set: option
      scope.availableWarehouses = Schema.warehouses.find({merchant: e.added._id})

    minimumResultsForSearch: -1
    formatSelection: formatMerchantSearch
    formatResult: formatMerchantSearch
    placeholder: 'CHỌN CHI NHÁNH'