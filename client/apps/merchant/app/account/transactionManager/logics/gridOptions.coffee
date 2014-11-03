Apps.Merchant.transactionManagerInit.push (scope) ->
  logics.transactionManager.gridOptions =
    itemTemplate: 'transactionThumbnail'
    reactiveSourceGetter: -> logics.transactionManager.transactionDetailFilter
    wrapperClasses: 'detail-grid row'

