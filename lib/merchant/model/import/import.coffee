#reUpdateMetroSummary=(importId)->
#  imports = Schema.imports.findOne(importId)
#  importDetails = Schema.importDetails.find({import: imports._id, finish: true}).fetch()
#  totalProduct = 0
#  for importDetail in importDetails
#    totalProduct += importDetail.importQuality
#  setOption={}
#  option =
#    importCount: 1
#    stockProductCount: totalProduct
#    availableProductCount: totalProduct
#
##  oldImports = Schema.imports.findOne({$and: [
##    {merchant: imports.merchant}
##    {'version.updateAt': {$lt: imports.version.updateAt}}
##    {submitted: true}
##  ]}, Sky.helpers.defaultSort())
##  console.log imports.version.updateAt.getDate()
##  console.log oldImports
##
##  unless oldImports
##    oldImports = {version: {}}
##    oldImports.version.updateAt = imports.version.updateAt
#
##  if imports.version.updateAt.getDate() == oldImports.version.updateAt.getDate()
##    option.importCountDay = totalProduct
##  else
##    setOption.importCountDay = totalProduct
##
##  if imports.version.updateAt.getMonth() == oldImports.version.updateAt.getMonth()
##    option.importCountMonth = totalProduct
##  else
##    setOption.importCountMonth = totalProduct
##
#  metroSummary = Schema.metroSummaries.findOne({merchant: imports.merchant})
#  Schema.metroSummaries.update metroSummary._id, $inc: option, $set: setOption

#Sky.global.reCalculateImport = (importId)->
#  if !warehouseImport = Schema.imports.findOne(importId) then console.log('Sai Import'); return
#  if !importDetails = Schema.importDetails.find({import: importId}).fetch() then console.log('Sai Import'); return
#  if importDetails.length > 0
#    totalPrice = 0
#    for detail in importDetails
#      totalPrice += (detail.importQuality * detail.importPrice)
#    Schema.imports.update importId, $set: {totalPrice: totalPrice, deposit: totalPrice, debit: 0}
#  else
#    Schema.imports.update importId, $set: {totalPrice: 0, deposit: 0, debit: 0}

Schema.add 'imports', class Import
  @createdByWarehouseAndSelect: (warehouseId, option)->
#    return ('Kho không chính xác') if !warehouse = Schema.warehouses.findOne(warehouseId)
#    return ('Mô Tả Không Được Đễ Trống') if !option.description
#    option.merchant   = warehouse.merchant
#    option.warehouse  = warehouse._id
#    option.creator    = Meteor.userId()
#    option.finish     = false
#    option.submitted   = false
#    option.totalPrice = 0
#    option.deposit    = 0
#    option.debit      = 0
#    option.emailCreator = Meteor.user().emails[0].address
#    option._id = Schema.imports.insert option, (error, result)-> console.log error if error
#    UserProfile.update {currentImport: option._id}
#    option
#
#  @new: (option)->
#    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
#    option.merchant   = userProfile.currentMerchant
#    option.warehouse  = userProfile.currentWarehouse
#    option.creator    = userProfile.user
#    option.finish     = false
#    option.submitted  = false
#    option.totalPrice = 0
#    option.deposit    = 0
#    option.debit      = 0
#    option.emailCreator = Meteor.user().emails[0].address
#    option
#
#
#
#  reCalculate: ->
#    importDetails = Schema.importDetails.find({import: @id}).fetch()
#    totalPrice = 0
#    if importDetails.length > 0
#      for detail in importDetails
#        totalPrice += (detail.importQuality * detail.importPrice)
#        option = {totalPrice: totalPrice, deposit: totalPrice, debit: 0}
#    else option = {totalPrice: 0, deposit: 0, debit: 0}
#
#    Schema.imports.update @id, $set: option
#
#  removeAll: ->
#    for importDetail in Schema.importDetails.find({import: @id}).fetch()
#      Schema.importDetails.remove(importDetail._id)
#    Schema.imports.remove(@id)
#    console.log("Đã xóa thành công phiếu nhập kho")
#
#  finish: ->
#    importDetails = Schema.importDetails.find({import: @id}).fetch()
#    if @data.finish == @data.submitted == false && importDetails.length < 1
#      for importDetail in importDetails
#        Schema.importDetails.update importDetail._id, $set: {finish: true}
#      Schema.imports.update @id, $set:{finish: true}
#      console.log('Phiếu nhập kho đang chờ duyệt')
#    else
#      console.log('Đã có lỗi trong quá trình xác nhận')
#
#  enabledEdit: ->
#    if @data.finish == true && @data.submitted == false
#      importDetails = Schema.importDetails.findOne({import: @id})
#      for importDetail in importDetails
#        Schema.importDetails.update importDetail._id, $set: {finish: false}
#      Schema.imports.update @id, $set:{finish: false}
#      console.log('Phiếu nhập kho đã có thể chỉnh sửa')
#    else
#      console.log('Đã có lỗi trong quá trình xác nhận')
#
#  submit: ->
#    if @data.finish == true && @data.submitted == false
#      importDetails = Schema.importDetails.find({import: @id}).fetch()
#      for importDetail in importDetails
#        product = Schema.products.findOne importDetail.product
#        return console.log('Không tìm thấy sản phẩm id:'+ importDetail.product) if !product
#
#      for importDetail in importDetails
#        productDetail= ProductDetail.newProductDetail(@data, importDetail)
#        Schema.productDetails.insert productDetail, (error, result) ->
#          if error then return console.log('Sai thông tin sản phẩm nhập kho')
#
#        product = Schema.products.findOne importDetail.product
#        option1=
#          totalQuality    : importDetail.importQuality
#          availableQuality: importDetail.importQuality
#          inStockQuality  : importDetail.importQuality
#
#        option2=
#          provider    : importDetail.provider
#          importPrice : importDetail.importPrice
#        option2.price = importDetail.salePrice if importDetail.salePrice
#
#        Schema.products.update product._id, $inc: option1, $set: option2, (error, result) ->
#          if error then return console.log('Sai thông tin sản phẩm nhập kho')
#
#      Schema.imports.update @id, $set:{finish: true, submitted: true}
#      warehouseImport = Schema.imports.findOne(importId)
#      transaction = Transaction.newByImport(warehouseImport)
#      transactionDetail = TransactionDetail.newByTransaction(transaction)
#      MetroSummary.updateMetroSummaryByImport(@id)
#      return ('Phiếu nhập kho đã được duyệt')
#    else
#      return ('Đã có lỗi trong quá trình xác nhận')