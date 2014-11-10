inventoryReviewRoute =
  template: 'inventoryReview',
  waitOnDependency: 'inventoryReview'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.inventoryReview, Apps.Merchant.inventoryReviewInit, 'inventoryReview')
      @next()
  data: ->
    Apps.setup(logics.inventoryReview, Apps.Merchant.inventoryReviewReactiveRun)

    return {
      gridOptions: logics.inventoryReview.gridOptions
      currentInventory            : Session.get('currentInventoryReview')
      currentInventoryDetails     : logics.inventoryReview.currentInventoryDetailReview
      currentInventoryProductLost : logics.inventoryReview.currentInventoryProductLostReview
    }

lemon.addRoute [inventoryReviewRoute], Apps.Merchant.RouterBase
