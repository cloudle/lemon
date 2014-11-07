logics.importReview = {}
Apps.Merchant.importReviewInit = []

Apps.Merchant.importReviewInit.push (scope) ->
  logics.importReview.availableMerchants  = Schema.merchants.find({})
  logics.importReview.availableWarehouses = Schema.warehouses.find({})
  logics.importReview.availableInventory  = Schema.inventories.find({warehouse: Session.get('myProfile').currentWarehouse})

logics.importReview.reactiveRun = ->

#runInitimportReviewTracker = (context) ->
#  return if Sky.global.importReviewTracker
#  Sky.global.importReviewTracker = Tracker.autorun ->
#    if currentWarehouse = Session.get("inventoryWarehouse")
#      inventories = Schema.inventories.find({warehouse: currentWarehouse._id}).fetch()
#      if inventories.length > 0 then Session.set "availableInventories", inventories
#      if inventories.length == 0 then Session.set "availableInventories"
#    else
#      Session.set "availableInventories"
#




