Meteor.publish 'currentInventory', (warehouseId)->
  mySession = Schema.userSessions.findOne({user: @userId})
  return [] if !mySession
  warehouse = Schema.warehouse.findOne({_id: warehouseId, })
  return [] if warehouse.checkingInventory is false
  inventory = Schema.inventories.find({_id: warehouse.inventory})
  detail    = Schema.inventoryDetails.find({inventory: warehouse.inventory})
  [inventory, detail]



Meteor.publish 'allInventoryAndDetail', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  inventory       = Schema.inventories.find({})
  inventoryDetail = Schema.inventoryDetails.find({})
  [inventory, inventoryDetail]


Meteor.publish 'allInventory', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.inventories.find({warehouse: myProfile.currentWarehouse})

Schema.inventories.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.inventoryDetails.allow
  insert: -> true
  update: -> true
  remove: -> true