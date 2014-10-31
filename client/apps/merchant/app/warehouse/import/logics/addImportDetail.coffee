Apps.Merchant.importInit.push (scope) ->
  logics.import.getExpireDate = (expire)->
    expire = $("[name=#{expire}]").datepicker().data().datepicker.dates[0]
    if expire > (new Date)
      expireDate = new Date(expire.getFullYear(), expire.getMonth(), expire.getDate())
    else null

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
  logics.import.addImportDetail = (option, importId) ->
    if currentImport = Schema.imports.findOne({_id: importId})
      importDetail = optionImportDetail(option, currentImport)

      findImportDetail = Schema.importDetails.findOne ({
        import      : importDetail.import
        product     : importDetail.product
        provider    : importDetail.provider
        importPrice : importDetail.importPrice
        expire      : importDetail.expire
      })
      console.log importDetail
      if findImportDetail
        reUpdateImportDetail(importDetail, findImportDetail)
      else
        Schema.importDetails.insert importDetail, (error, result) -> console.log error if error

      logics.import.reCalculateImport(importId)