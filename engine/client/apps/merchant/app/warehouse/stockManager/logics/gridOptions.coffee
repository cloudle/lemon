Apps.Merchant.stockManagerInit.push (scope) ->
  logics.stockManager.gridOptions =
    itemTemplate: 'stockThumbnail'
    reactiveSourceGetter: -> logics.stockManager.availableProducts
    wrapperClasses: 'detail-grid row'
