Apps.Merchant.importReviewInit.push (scope) ->
  logics.importReview.gridOptions =
    itemTemplate: 'inventoryThumbnail'
    reactiveSourceGetter: -> logics.importReview.availableInventory
    wrapperClasses: 'detail-grid row'
