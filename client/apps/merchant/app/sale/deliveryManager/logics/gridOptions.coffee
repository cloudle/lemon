Apps.Merchant.deliveryManagerInit.push (scope) ->
  scope.waitingGridOptions =
    itemTemplate: 'deliveryManagerThumbnail'
    reactiveSourceGetter: -> scope.waitingDeliveries
  scope.deliveringGridOptions =
    itemTemplate: 'deliveryManagerThumbnail'
    reactiveSourceGetter: -> scope.deliveringDeliveries
  scope.doneGridOptions =
    itemTemplate: 'deliveryManagerThumbnail'
    reactiveSourceGetter: -> scope.doneDeliveries