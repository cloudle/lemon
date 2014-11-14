formatBranchSelect = (item) -> "#{item.name}" if item

Apps.Merchant.staffManagerInit.push (scope) ->
  logics.staffManager.branchSelectOptions =
    query: (query) -> query.callback
      results: Schema.merchants.find().fetch()
    initSelection: (element, callback) ->
      callback(Schema.merchants.findOne(Session.get('mySession').createStaffBranchSelection) ? 'skyReset')
    reactiveValueGetter: -> Session.get('mySession').createStaffBranchSelection ? 'skyReset'
    changeAction: (e) ->
      option =
        createStaffBranchSelection : e.added._id
        createStaffWarehouseSelection: Schema.warehouses.findOne({merchant: e.added._id, isRoot: true})?._id ? 'skyReset'
      Schema.userSessions.update Session.get('mySession')._id, $set: option
      scope.availableWarehouses = Schema.warehouses.find({merchant: e.added._id})


    minimumResultsForSearch: -1
    formatSelection: formatBranchSelect
    formatResult: formatBranchSelect