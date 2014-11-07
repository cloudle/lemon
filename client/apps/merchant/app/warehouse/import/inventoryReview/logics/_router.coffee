importReviewRoute =
  template: 'importReview',
  waitOnDependency: 'importReview'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.importReview, Apps.Merchant.importReviewInit, 'importReview')
      @next()
  data: ->
    logics.importReview.reactiveRun()

    return {
      gridOptions: logics.importReview.gridOptions
    }

lemon.addRoute [importReviewRoute], Apps.Merchant.RouterBase
