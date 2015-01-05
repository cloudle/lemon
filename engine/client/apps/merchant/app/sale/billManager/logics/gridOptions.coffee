Apps.Merchant.billManagerInit.push (scope) ->
  logics.billManager.gridOptions =
    itemTemplate: 'billThumbnail'
    reactiveSourceGetter: -> logics.billManager.availableBills
    wrapperClasses: 'detail-grid row'