logics.inventoryReview = {}
Apps.Merchant.inventoryReviewInit = []
Apps.Merchant.inventoryReviewReactiveRun = []

Apps.Merchant.inventoryReviewInit.push (scope) ->
  scope.availableMerchants  = Schema.merchants.find({})
  scope.availableWarehouses = Schema.warehouses.find({})
  scope.availableInventory  = Schema.inventories.find({warehouse: Session.get('myProfile').currentWarehouse})

Apps.Merchant.inventoryReviewReactiveRun.push (scope) ->
  if Session.get('currentInventoryReview')
    scope.currentInventoryDetailReview      = Schema.inventoryDetails.find {inventory: Session.get('currentInventoryReview')._id, lostQuality: {$gt: 0}}
    scope.currentInventoryProductLostReview = Schema.productLosts.find {inventory: Session.get('currentInventoryReview')._id}



