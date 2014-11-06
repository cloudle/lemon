formatBranchSelect = (item) -> "#{item.name}" if item

Apps.Merchant.staffManagerInit.push (scope) ->
  currentWarehouse = Schema.warehouses.findOne(Session.get('myProfile').currentWarehouse)
  Session.set 'createStaffBranchSelection', Schema.merchants.findOne(currentWarehouse.merchant)

  logics.staffManager.branchSelectOptions =
    query: (query) -> query.callback
      results: Schema.merchants.find().fetch()
    initSelection: (element, callback) -> callback Session.get('createStaffBranchSelection')
    changeAction: (e) ->
      Session.set('createStaffBranchSelection', e.added)
    reactiveValueGetter: -> Session.get('createStaffBranchSelection')
    formatSelection: formatBranchSelect
    formatResult: formatBranchSelect