logics.inventoryManager = {}
Apps.Merchant.inventoryManagerInit = []

Apps.Merchant.inventoryManagerInit.push (scope) ->
  logics.inventoryManager.merchant = []
  logics.inventoryManager.warehouse = []

logics.inventoryManager.reactiveRun = ->



#    if Session.get('inventoryWarehouse')
#      inventory = Schema.inventories.findOne(Session.get('inventoryWarehouse').inventory)
#      if inventory?.creator == Meteor.userId()
#        Session.set "currentInventory", inventory
#      else
#        Session.set "currentInventory"
#    else
#      Session.set "currentInventory"
#
#    if Session.get('currentInventory')
#      Session.set "availableProductDetails", Schema.inventoryDetails.find({inventory: Session.get('currentInventory')._id}).fetch()
#    else
#      Session.set "availableProductDetails"


