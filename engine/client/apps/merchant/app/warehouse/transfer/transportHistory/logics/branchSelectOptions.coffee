formatMerchantSearch = (item) -> "#{item.name}" if item

Apps.Merchant.transportHistoryInit.push (scope) ->
  scope.branchSelectOptions =
    query: (query) -> query.callback
      results: scope.availableMerchants.fetch()
    initSelection: (element, callback) ->
      callback(Schema.merchants.findOne(Session.get('mySession')?.currentTransportBranchSelection) ? 'skyReset')
    reactiveValueGetter: -> Session.get('mySession')?.currentTransportBranchSelection ? 'skyReset'
    changeAction: (e) ->
      option =
        currentTransportBranchSelection   : e.added._id
        currentTransportWarehouseSelection: Schema.warehouses.findOne({merchant: e.added._id, isRoot: true})._id
      Schema.userSessions.update Session.get('mySession')._id, $set: option
      scope.availableWarehouses = Schema.warehouses.find({merchant: e.added._id})

    minimumResultsForSearch: -1
    formatSelection: formatMerchantSearch
    formatResult: formatMerchantSearch
    placeholder: 'CHỌN CHI NHÁNH'