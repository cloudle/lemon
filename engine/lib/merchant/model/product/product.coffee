Schema.add 'products', "Product", class Product
  @insideWarehouse: (warehouseId) ->
    @schema.find({
      warehouse: warehouseId
#      availableQuality: {$gt: 0}
#      basicDetailModeEnabled: false
    },{sort: {'version.createdAt': -1}})

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

  @createNew: (productCode, name, skull, price, warehouseId)->
    if myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      warehouse = Schema.warehouses.findOne({_id: warehouseId, merchant: myProfile.currentMerchant}) if warehouseId
      newProduct =
        merchant    : warehouse?.merchant ? myProfile.currentMerchant
        warehouse   : warehouse?._id ? myProfile.currentWarehouse
        creator     : myProfile.user
        name        : name

      newProduct.productCode = productCode if productCode
      newProduct.skulls      = skulls if skulls
      newProduct.price       = price if price


      existedQuery = {merchant: newProduct.merchant, warehouse: newProduct.warehouse, name: newProduct.name}
      existedQuery.skulls = newProduct.skulls if newProduct.skulls

      if @schema.findOne existedQuery
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

  @optionByProfile: (buildInProductId, profile) ->
    productOption =
      createMerchant : profile.currentMerchant
      parentMerchant : profile.parentMerchant
      merchant       : profile.currentMerchant
      warehouse      : profile.currentWarehouse
      buildInProduct : buildInProductId
    return productOption