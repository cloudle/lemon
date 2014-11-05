Apps.Merchant.inventoryReviewInit.push (scope) ->
  logics.inventoryReview.gridOptions =
    itemTemplate: 'inventoryThumbnail'
    reactiveSourceGetter: -> logics.inventoryReview.availableInventory
    wrapperClasses: 'detail-grid row'
