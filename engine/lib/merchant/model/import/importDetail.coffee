getExpireDate = (productionDate, timeUse)->
  new Date(productionDate.getFullYear(), productionDate.getMonth(), productionDate.getDate() + timeUse)



Schema.add 'importDetails', "ImportDetail", class ImportDetail
  @findBy: (importId, merchantId = null, warehouseId = null)->
    if !merchantId && !warehouseId then myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.find({
      import   : importId
      merchant : merchantId ? myProfile.currentMerchant
      warehouse: warehouseId ? myProfile.currentWarehouse
    })

  @newImportDetail: (imports, product)->
    option=
      merchant      : imports.merchant
      warehouse     : imports.warehouse
      import        : imports._id
      product       : imports.currentProduct
      importQuality : Number(imports.currentQuality)
      importPrice   : Number(imports.currentImportPrice)
      totalPrice    : Number(imports.currentImportPrice)*Number(imports.currentQuality)
      submitted     : false
    option.provider  = imports.currentProvider  if imports.currentProvider
    option.expire    = imports.currentExpire    if imports.currentExpire
    option.salePrice = imports.currentPrice    if imports.currentPrice
    option

  @new: (importId, productId, quality, price, providerId = null, priceSale = null, productionDate = null, timeUse = null)->
    if myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      imports  = Schema.imports.findOne({_id: importId, warehouse: myProfile.currentWarehouse})
      product  = Schema.products.findOne({_id: productId, warehouse: myProfile.currentWarehouse})
      provider = Schema.providers.findOne({_id: providerId, parentMerchant: myProfile.parentMerchant})

      importDetail =
        merchant      : imports.merchant
        warehouse     : imports.warehouse
        import        : imports._id
        product       : product._id
        provider      : provider._id if provider
        importQuality : quality
        importPrice   : price
        salePrice     : priceSale
        totalPrice    : quality * price
        productionDate: productionDate if productionDate
        timeUse       : timeUse if productionDate and timeUse
        expire        : getExpireDate(productionDate, timeUse)  if productionDate and timeUse

      findImportDetail = Schema.importDetails.findOne({
        import          : importDetail.import
        product         : importDetail.product
        importPrice     : Number(importDetail.importPrice)
        provider        : importDetail.provider if importDetail.provider
        productionDate  : importDetail.productionDate if importDetail.productionDate
        timeUse         : importDetail.timeUse if importDetail.timeUse
        expire          : importDetail.expire if importDetail.expire
      })

      if findImportDetail
        option = $inc:{importQuality:importDetail.importQuality, totalPrice: importDetail.importQuality * findImportDetail.importPrice}
        Schema.importDetails.update findImportDetail._id, option, (error, result) -> console.log error if error
      else
        @schema.insert importDetail, (error, result) -> console.log error if error


