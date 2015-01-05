logics.inventoryManager.successInventory = (warehouseId) ->
  try
    throw 'Bạn chưa đăng nhập.' unless userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
#    throw 'Bạn không có quyền xác nhận phiếu kiểm kho.' unless Role.hasPermission(userProfile._id, Sky.system.merchantPermissions.inventoryConfirm.key)
    throw 'Kho không tồn tại' if !warehouse = Schema.warehouses.findOne({_id: warehouseId})
    throw 'Inventory khong ton tai' if !inventory = Schema.inventories.findOne({_id: warehouse.inventory}) 

    for detail in Schema.inventoryDetails.find({inventory: inventory._id}).fetch()
      throw 'Lỗi, Chưa Submitted hết các sp' if detail.lock == false || detail.submit == false

    temp = false
    for detail in Schema.inventoryDetails.find({inventory: inventory._id}).fetch()
      option =
        realQuality : detail.realQuality-detail.saleQuality
        saleQuality : 0
        success     : true
        successDate : new Date
        status      : true

      if detail.lostQuality > 0
        temp = true
        option.status = false
        updateProduct =
          inStockQuality   : -detail.lostQuality
          availableQuality : -detail.lostQuality

        Schema.productLosts.insert ProductLost.new(warehouse, detail)
        Schema.products.update detail.product, $inc: updateProduct, (error, result) -> console.log error if error
        Schema.productDetails.update detail.productDetail, $inc: updateProduct, (error, result) -> console.log error if error
      Schema.inventoryDetails.update detail._id, $set: option, (error, result) -> console.log error if error
    Meteor.call 'inventoryNewCreate', userProfile, inventory._id
    updateInventory = {submit: true, success: true}
    if temp
      updateInventory.success = false
      MetroSummary.updateMetroSummaryByInventory(inventory._id)

    Schema.inventories.update inventory._id, $set: updateInventory
    Schema.warehouses.update warehouseId, { $set:{checkingInventory: false}, $unset:{inventory: ""} }

    console.log 'Đã Xác Nhận Kiểm Kho.'
  catch error
    return error
