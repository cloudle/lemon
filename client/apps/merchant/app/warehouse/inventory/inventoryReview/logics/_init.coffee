logics.inventoryReview = {}
Apps.Merchant.inventoryReviewInit = []

Apps.Merchant.inventoryReviewInit.push (scope) ->
  logics.inventoryReview.availableMerchants  = Schema.merchants.find({})
  logics.inventoryReview.availableWarehouses = Schema.warehouses.find({})
  logics.inventoryReview.availableInventory  = Schema.inventories.find({warehouse: Session.get('myProfile').currentWarehouse})

logics.inventoryReview.reactiveRun = ->

#runInitInventoryReviewTracker = (context) ->
#  return if Sky.global.inventoryReviewTracker
#  Sky.global.inventoryReviewTracker = Tracker.autorun ->
#    if currentWarehouse = Session.get("inventoryWarehouse")
#      inventories = Schema.inventories.find({warehouse: currentWarehouse._id}).fetch()
#      if inventories.length > 0 then Session.set "availableInventories", inventories
#      if inventories.length == 0 then Session.set "availableInventories"
#    else
#      Session.set "availableInventories"
#




