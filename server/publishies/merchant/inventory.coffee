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


Meteor.publishComposite 'inventoryReviewInWarehouse', ->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.inventories.find {submitted: true, warehouse: myProfile.currentWarehouse}
    children: [
      find: (inventory) -> Schema.userProfiles.find {user: inventory.creator}
    ]
  }

Meteor.publishComposite 'inventoryDetailInWarehouse', (inventoryId)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.inventoryDetails.find {inventory: inventoryId, warehouse: myProfile.currentWarehouse}
    children: [
      find: (inventoryDetail) -> Schema.products.find {_id: inventoryDetail.product}
    ]
  }





Schema.inventories.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.inventoryDetails.allow
  insert: -> true
  update: -> true
  remove: -> true