createInventory = (warehouse, userProfile, description, productDetails)->
  if inventoryId = Schema.inventories.insert({
    merchant    : warehouse.merchant
    warehouse   : warehouse._id
    creator     : userProfile.user
    description : description
  })

    for productDetail in productDetails.fetch()
      Schema.inventoryDetails.insert({
        merchant            : warehouse.merchant
        warehouse           : warehouse._id
        creator             : userProfile.user
        inventory           : inventoryId
        product             : productDetail.product
        productDetail       : productDetail._id
        lockOriginalQuality : productDetail.inStockQuality
      })

    Schema.inventories.update inventoryId, $set: {detail: true}
    Schema.warehouses.update warehouse._id, {$set:{checkingInventory: true, inventory: inventoryId}}

Meteor.methods
  createNewInventory: (warehouseId, description)->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if !userProfile then throw new Meteor.Error("Chưa đăng nhập."); return

    warehouse = Schema.warehouses.findOne({_id: warehouseId, merchant: userProfile.currentMerchant})
    if !warehouse then throw new Meteor.Error("Warehouse không chính xác"); return
    if warehouse.checkingInventory == true then throw new Meteor.Error("Warehouse đang kiểm kho."); return

    productDetails = Schema.productDetails.find({warehouse: warehouseId,  inStockQuality: { $gt: 0 } })
    if productDetails.count() < 1 then throw new Meteor.Error("Warehouse đang trống."); return

    createInventory(warehouse, userProfile, description, productDetails)
    return 'Tao thanh cong'


