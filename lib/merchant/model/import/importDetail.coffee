reUpdateImportDetail = (newImportDetail, oldImportDetail) ->
  totalPrice = newImportDetail.importQuality  * oldImportDetail.importPrice
  Schema.importDetails.update oldImportDetail._id, $inc:{ importQuality : newImportDetail.importQuality , totalPrice: totalPrice}
  , (error, result) -> console.log error if error


Schema.add 'importDetails', class ImportDetail
  @findBy: (importId, merchantId = null, warehouseId = null)->
    if !merchantId && !warehouseId then myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.find({
      import   : importId
      merchant : merchantId ? myProfile.currentMerchant
      warehouse: warehouseId ? myProfile.currentWarehouse
    })

  @newImportDetail: (imports, product)->
    option=
      import        : imports._id
      product       : imports.currentProduct
      importQuality : Number(imports.currentQuality)
      importPrice   : Number(imports.currentImportPrice)
      totalPrice    : Number(imports.currentImportPrice)*Number(imports.currentQuality)
      finish        : false
      styles        : Sky.helpers.randomColor()
    option.provider  = imports.currentProvider  if imports.currentProvider
    option.expire    = imports.currentExpire    if imports.currentExpire
    option.salePrice = imports.currentPrice    if imports.currentPrice
    option
