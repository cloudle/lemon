reUpdateImportDetail = (newImportDetail, oldImportDetail) ->
  totalPrice = newImportDetail.importQuality  * oldImportDetail.importPrice
  Schema.importDetails.update oldImportDetail._id, $inc:{
    unitQuality : newImportDetail.unitQuality
    importQuality : newImportDetail.importQuality
    totalPrice: totalPrice
  }, (error, result) -> console.log error if error
  return oldImportDetail._id

Apps.Merchant.importInit.push (scope) ->
  scope.reCalculateImport = (importId)->
    if currentImport = Schema.imports.findOne(
      {
        _id: importId
        warehouse: Session.get('myProfile').currentWarehouse
        merchant : Session.get('myProfile').currentMerchant
      } )
      importDetails = Schema.importDetails.find({import: importId}).fetch()
      totalPrice = 0
      if importDetails.length > 0
        for detail in importDetails
          totalPrice += (detail.importQuality * detail.importPrice)
          option = {totalPrice: totalPrice, debit: totalPrice - currentImport.deposit}
#          option = {totalPrice: totalPrice, deposit: totalPrice, debit: 0}
      else option = {totalPrice: 0, deposit: 0, debit: 0}
      console.log option
      Import.update importId, $set: option

  scope.addImportDetail = (currentProduct) ->
#    productionDate = logics.import.getProductionDate()
#    if productionDate and Session.get('timesUseProduct') > 0
#      option.productionDate = productionDate
#      option.timeUse = Session.get('timesUseProduct')
#      option.expire  = new Date(productionDate.getFullYear(), productionDate.getMonth(), productionDate.getDate() + option.timeUse)

    #      if expireDate = logics.import.getExpireDate() and Session.get('timesUseProduct') > 0
    #        option.expire  = expireDate
    #        option.timeUse = Session.get('timesUseProduct')
    #        option.productionDate  = new Date(productionDate.getFullYear(), productionDate.getMonth(), productionDate.getDate() - option.timeUse)

    if currentImport = Session.get('currentImport')
      importDetail =
        merchant      : currentImport.merchant
        warehouse     : currentImport.warehouse
        import        : currentImport._id
        product       : currentProduct.product._id
        unitQuality   : 1
        unitPrice     : currentProduct.product.importPrice ? 0
        conversionQuality: 1

      if currentProduct.unit
        importDetail.unit = currentProduct.unit._id
        importDetail.unitPrice = currentProduct.unit.price
        importDetail.conversionQuality = currentProduct.unit.conversionQuality

      importDetail.importQuality = importDetail.unitQuality * importDetail.conversionQuality
      importDetail.importPrice   = importDetail.unitPrice/importDetail.conversionQuality
      importDetail.totalPrice    = importDetail.importQuality * importDetail.importPrice
#      importDetail.provider = currentProduct.product.provider if currentProduct.product.provider

      existedQuery = {
        import    : importDetail.import
        product   : importDetail.product
        unitPrice : importDetail.unitPrice
      }
      existedQuery.provider = importDetail.provider if importDetail.provider
      existedQuery.unit = importDetail.unit if importDetail.unit

      if findImportDetail = Schema.importDetails.findOne(existedQuery)
        importDetailId = reUpdateImportDetail(importDetail, findImportDetail)
      else
        importDetailId = Schema.importDetails.insert importDetail, (error, result) -> console.log error if error
      logics.import.reCalculateImport(Session.get('currentImport')._id)

      return importDetailId