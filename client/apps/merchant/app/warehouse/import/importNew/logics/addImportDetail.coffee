Apps.Merchant.importInit.push (scope) ->
  logics.import.reCalculateImport = (importId)->
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
          option = {totalPrice: totalPrice, deposit: totalPrice, debit: 0}
      else option = {totalPrice: 0, deposit: 0, debit: 0}
      Import.update importId, $set: option


reUpdateImportDetail = (newImportDetail, oldImportDetail) ->
  totalPrice = newImportDetail.importQuality  * oldImportDetail.importPrice
  Schema.importDetails.update oldImportDetail._id, $inc:{ importQuality : newImportDetail.importQuality , totalPrice: totalPrice}
  , (error, result) -> console.log error if error

optionImportDetail = (option, currentImport)->
  option.merchant   = currentImport.merchant
  option.warehouse  = currentImport.warehouse
  option.import     = currentImport._id
  option.totalPrice = option.importQuality * option.importPrice
  option

checkValidationOption = (option, currentImport) -> true

Apps.Merchant.importInit.push (scope) ->
  logics.import.addImportDetail = (event, template) ->
    option =
      product       : Session.get('currentImport').currentProduct
      importQuality : Session.get('currentImport').currentQuality
      importPrice   : Session.get('currentImport').currentImportPrice

    option.provider  = Session.get('currentImport').currentProvider if Session.get('currentImport').currentProvider
    option.salePrice = Session.get('currentImport').currentPrice if Session.get('currentImport').currentPrice

#    productionDate = logics.import.getProductionDate()
#    if productionDate and Session.get('timesUseProduct') > 0
#      option.productionDate = productionDate
#      option.timeUse = Session.get('timesUseProduct')
#      option.expire  = new Date(productionDate.getFullYear(), productionDate.getMonth(), productionDate.getDate() + option.timeUse)

    #      if expireDate = logics.import.getExpireDate() and Session.get('timesUseProduct') > 0
    #        option.expire  = expireDate
    #        option.timeUse = Session.get('timesUseProduct')
    #        option.productionDate  = new Date(productionDate.getFullYear(), productionDate.getMonth(), productionDate.getDate() - option.timeUse)


    if currentImport = Schema.imports.findOne({_id: Session.get('currentImport')._id})
      importDetail = optionImportDetail(option, currentImport)

      findImportDetail = Schema.importDetails.findOne ({
        import      : importDetail.import
        product     : importDetail.product
        provider    : importDetail.provider
        importPrice : importDetail.importPrice
        expire      : importDetail.expire
      })

      if findImportDetail
        reUpdateImportDetail(importDetail, findImportDetail)
      else
        Schema.importDetails.insert importDetail, (error, result) -> console.log error if error

      logics.import.reCalculateImport(Session.get('currentImport')._id)