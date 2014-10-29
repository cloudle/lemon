#checkingAndAddImportDetail = (currentImport)->
#  if !imports = Schema.imports.findOne({_id: importId}) then return {error: true, message: "Phiếu nhập kho không tồn tại"}
#  if imports.finish == true then return {error: true, message: "Phiếu nhập kho đang chờ duyệt, không thể thêm sản phẩm"}
#  if !product = Schema.products.findOne(imports.currentProduct) then return {error: true, message: "Không tìm thấy sản phẩm nhập kho"}
#  #    importDetails = Schema.importDetails.find({import: importId}).fetch()
#  importDetail = @newImportDetail(imports, product)
#
#  findImportDetail = Schema.importDetails.findOne ({
#    import      : importDetail.import
#    product     : importDetail.product
#    provider    : importDetail.provider
#    importPrice : importDetail.importPrice
#    expire      : importDetail.expire
#  })
#  if findImportDetail
#    reUpdateImportDetail(importDetail, findImportDetail)
#  else
#    Schema.importDetails.insert importDetail, (error, result) -> console.log error if error
#
#  Sky.global.reCalculateImport(importId)
#
#
#
#logics.imports.addImportDetail = (event, template, currentImport) ->
#  checkingAndAddImportDetail(currentImport)
#
#
#  expire = template.ui.$expire.data('datepicker').dates[0]
#  if expire > (new Date)
#    expireDate = new Date(expire.getFullYear(), expire.getMonth(), expire.getDate())
#    Import.update(currentImport._id, {$set: {currentExpire: expireDate}})
#  else
#    Import.update(currentImport._id, {$unset: {currentExpire: true}})
#
#  console.log ImportDetail.createByImport Session.get('currentImport')._id