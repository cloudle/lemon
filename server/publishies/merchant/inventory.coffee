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
      inventory = Schema.inventories.findOne({_id: inventoryId, creator: self.userId})
      return EmptyQueryResult if !inventory
      Schema.inventoryDetails.find {inventory: inventory._id}
    children: [
      find: (inventoryDetail) -> Schema.productDetails.find {_id: inventoryDetail.productDetail}
      children: [
        find: (productDetail) -> Schema.products.find {_id: productDetail.product}
      ]
    ]
  }

Meteor.publishComposite 'productLostInInventory', (inventoryId)->
  self = @
  return {
    find: ->
      inventory = Schema.inventories.findOne({_id: inventoryId, creator: self.userId})
      return EmptyQueryResult if !inventory
      Schema.productLosts.find {inventory: inventory._id}
    children: [
      find: (productLost) -> Schema.productDetails.find {_id: productLost.productDetail}
      children: [
        find: (productDetail) -> Schema.products.find {_id: productDetail.product}
      ]
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