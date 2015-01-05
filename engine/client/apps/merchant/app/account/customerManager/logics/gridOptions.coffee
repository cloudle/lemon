Apps.Merchant.customerManagerInit.push (scope) ->
  logics.customerManager.gridOptions =
    itemTemplate: 'customerThumbnail'
    reactiveSourceGetter: -> logics.customerManager.availableCustomers
    wrapperClasses: 'detail-grid row'