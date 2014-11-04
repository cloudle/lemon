Apps.Merchant.branchManagerInit.push (scope) ->
  logics.branchManager.gridOptions =
    itemTemplate: 'merchantThumbnail'
    reactiveSourceGetter: -> Schema.merchants.find({})
#    reactiveSourceGetter: -> logics.branchManager.availableBranch
    wrapperClasses: 'detail-grid row'
