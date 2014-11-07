logics.importReview = {}
Apps.Merchant.importReviewInit = []

Apps.Merchant.importReviewInit.push (scope) ->
  scope.availableMerchants  = Schema.merchants.find({})
  scope.availableWarehouses = Schema.warehouses.find({})
  scope.importReviews = Schema.imports.find {warehouse: Session.get('myProfile').currentWarehouse}

logics.importReview.reactiveRun = ->
  if Session.get('currentImportReview')
    logics.importReview.currentImportReviewDetail = Schema.importDetails.find {import: Session.get('currentImportReview')._id}






