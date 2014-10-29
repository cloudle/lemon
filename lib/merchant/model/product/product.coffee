Schema.add 'products', class Product
  @insideWarehouse: (warehouseId) -> @schema.find({warehouse: warehouseId})

  @findBy: (productId, warehouseId = null, merchantId = null)->
    if !merchantId && !warehouseId then myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.findOne({
      _id      : productId
      merchant : merchantId ? myProfile.currentMerchant
      warehouse: warehouseId ? myProfile.currentWarehouse
    })