Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.gridOptions =
    itemTemplate: 'returnProductThumbnail'
    reactiveSourceGetter: -> logics.returns.availableReturnDetails
    wrapperClasses: 'detail-grid row'