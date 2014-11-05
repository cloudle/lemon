inventoryReviewRoute =
  template: 'inventoryReview',
  waitOnDependency: 'inventoryReview'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.inventoryReview, Apps.Merchant.inventoryReviewInit, 'inventoryReview')
      @next()
  data: ->
    logics.inventoryReview.reactiveRun()

    return {
      gridOptions: logics.inventoryReview.gridOptions
    }

lemon.addRoute [inventoryReviewRoute], Apps.Merchant.RouterBase
