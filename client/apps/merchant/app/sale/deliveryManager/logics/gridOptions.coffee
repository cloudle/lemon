Apps.Merchant.deliveryManagerInit.push (scope) ->
  logics.deliveryManager.gridOptions =
    itemTemplate: 'deliveryManagerThumbnail'
    reactiveSourceGetter: -> logics.deliveryManager.availableDeliveries
    wrapperClasses: 'detail-grid row'