Schema.add 'products', class Product
  @insideWarehouse: (warehouseId) -> @schema.find({warehouse: warehouseId})

  @findBy: (productId, warehouseId = null, merchantId = null)->
    if !merchantId && !warehouseId then myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.findOne({
      _id      : productId
      merchant : merchantId ? myProfile.currentMerchant
      warehouse: warehouseId ? myProfile.currentWarehouse
    })

  @findCreator: (creatorId, warehouseId)->
    @schema.find
      warehouse   : warehouseId
      creator     : creatorId

  @canDeleteByMeInside: (warehouseId = null)->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      @schema.find
        warehouse   : warehouseId ? userProfile.currentWarehouse
        creator     : userProfile.user
        allowDelete : true

  @createNew: (productCode, name, skull, warehouseId = null)->
    if myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      warehouse = Schema.warehouses.findOne({_id: warehouseId, merchant: myProfile.currentMerchant})
      newProduct =
        merchant    : warehouse.merchant ? myProfile.currentMerchant
        warehouse   : warehouse._id ? myProfile.currentWarehouse
        creator     : myProfile.user
        productCode : productCode
        name        : name
        skulls      : [skull]

      findProduct =  @schema.findOne({
        merchant    : newProduct.merchant
        warehouse   : newProduct.warehouse
        productCode : newProduct.productCode
        skulls      : newProduct.skulls})

      if findProduct
        {error:'Tạo mới sản phẩm bị trùng lặp.'}
      else
        @schema.insert newProduct, (error, result)-> if error then {error: error} else {}

  @destroyByCreator: (productId) ->
    product = @schema.findOne({_id: productId, creator: Meteor.userId()})
    if product.totalQuality is 0
      @schema.remove product._id
      {}
    else
      {error:'Không thể xóa được sản phẩm.'}




