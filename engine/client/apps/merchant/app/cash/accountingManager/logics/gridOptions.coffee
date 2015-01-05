Apps.Merchant.accountingManagerInit.push (scope) ->
  logics.accountingManager.gridOptions =
    itemTemplate: 'accountingManagerThumbnail'
    reactiveSourceGetter: -> logics.accountingManager.availableAccounting
    wrapperClasses: 'detail-grid row'