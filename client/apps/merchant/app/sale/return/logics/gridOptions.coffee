Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.gridOptions =
    itemTemplate: 'returnProductThumbnail'
    reactiveSourceGetter: -> logics.returns.currentReturnDetails
    wrapperClasses: 'detail-grid row'