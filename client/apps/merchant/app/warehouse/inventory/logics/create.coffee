createInventory = (warehouse, userProfile, description)->
  try
    option =
      merchant    : warehouse.merchant
      warehouse   : warehouse._id
      creator     : userProfile.user
      description : description
    Schema.inventories.insert option, (error, result) ->
      if error then throw error
      else
        optionWarehouse = {$set:{checkingInventory: true, inventory: result}}
        Schema.warehouses.update warehouseId, optionWarehouse, (error, result) ->
          if error then throw error
  catch error
    return {error: error}

createInventoryDetail = (warehouse)->
  for productDetail in Schema.productDetails.find({warehouse: warehouse._id}).fetch()
    option =
      inventory           : warehouse.inventory
      product             : productDetail.product
      productDetail       : productDetail._id
      lockOriginalQuality : productDetail.inStockQuality

    Schema.inventoryDetails.insert option, (error, result) ->
      if error then console.log error
  Schema.inventories.update warehouse.inventory, $set: {detail: true}, (error, result) ->
    if error then console.log error


logics.inventoryManager.createNewInventory = (warehouseId, description)->
  try
    throw 'Bạn chưa đăng nhập.' if !userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
#    throw 'Bạn không có quyền tạo phiếu kiểm kho.' unless Role.hasPermission(userProfile._id, Sky.system.merchantPermissions.inventoryCreate.key)
    throw 'Kho không tồn tại.' if !warehouse = Schema.warehouses.findOne({_id: warehouseId, merchant: userProfile.currentMerchant})
    throw 'Kho đang kiểm kho, không thể tạo phiếu kiểm kho mới' if warehouse.checkingInventory == true
    throw 'Kho trống, không thể kiểm kho.' if !Schema.productDetails.findOne({warehouse: warehouseId,  inStockQuality: { $gt: 0 } })

    createInventory(warehouse, userProfile, description)
    createInventoryDetail(warehouse)
    console.log 'Tạo phiếu kiểm kho thành công.'; true
  catch error
    console.log error; false