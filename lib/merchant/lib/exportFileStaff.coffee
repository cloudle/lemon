#checkValidationFileImport = (column)->
#  data = []
#  data.push(item.trim()) for item in column
#
#  productColumn = {}
#  productColumn.barcode        = data.indexOf("Tài Khoản")
#  productColumn.name           = data.indexOf("Mật Khẩu")
#  productColumn.skull          = data.indexOf("Chi Nhánh")
#  productColumn.quality        = data.indexOf("Kho Hàng")
#  productColumn.price          = data.indexOf("Tên Nhân Viên")
#  productColumn.priceSale      = data.indexOf("Giới Tính")
#  productColumn.productionDate = data.indexOf("Sinh Nhật")
#  productColumn.expireDate     = data.indexOf("Ngày Gia Nhập")
#  productColumn.providerName   = data.indexOf("Nhà Cung Cấp")
#
#  (return productColumn = {} if value is -1) for key, value of productColumn
#  productColumn
#
#
#checkAndAddNewMerchantAndWarehouse = (column, data, profile)->
#  for item in data
#    if !Schema.providers.findOne({parentMerchant: profile.parentMerchant, name: item[column.providerName]})
#      Provider.createNew(item[column.providerName])
#
#checkAndAddNewProduct = (column, data, profile)->
#  for item in data
#    if !Schema.products.findOne({
#      merchant    : profile.currentMerchant
#      warehouse   : profile.currentWarehouse
#      productCode : item[column.barcode]
#      skulls      : item[column.skull]
#    }) then Product.createNew(item[column.barcode], item[column.name], [item[column.skull]], profile.currentWarehouse)
#
#addMerchantStaff = (column, data, profile)->
#  for item in data
#    imports = logics.import.currentImport
#    provider = Schema.providers.findOne({parentMerchant: profile.parentMerchant, name: item[column.providerName]})
#    product = Schema.products.findOne({
#      merchant    : profile.currentMerchant
#      warehouse   : profile.currentWarehouse
#      productCode : item[column.barcode]
#      skulls      : item[column.skull]
#    })
#
#    importDetail =
#      merchant      : imports.merchant
#      warehouse     : imports.warehouse
#      import        : imports._id
#      product       : product._id
#      provider      : provider._id
#      importQuality : item[column.quality]
#      importPrice   : item[column.price]
#      salePrice     : item[column.priceSale]
#      totalPrice    : item[column.quality] * item[column.price]
#      productionDate: moment(item[column.productionDate], "DD/MM/YYYY")._d
#      expire        : moment(item[column.expireDate], "DD/MM/YYYY")._d
#
#    findImportDetail = Schema.importDetails.findOne({
#      import          : importDetail.import
#      product         : importDetail.product
#      importPrice     : Number(importDetail.importPrice)
#      provider        : importDetail.provider if importDetail.provider
#      productionDate  : importDetail.productionDate if importDetail.productionDate
#      timeUse         : importDetail.timeUse if importDetail.timeUse
#      expire          : importDetail.expire if importDetail.expire
#    })
#
#    if findImportDetail
#      option = $inc:{importQuality:importDetail.importQuality, totalPrice: importDetail.importQuality * findImportDetail.importPrice}
#      Schema.importDetails.update findImportDetail._id, option, (error, result) -> console.log error if error
#    else
#      Schema.importDetails.insert importDetail, (error, result) -> console.log error if error
#
#
#Apps.Merchant.exportFileImport = (data)->
#  profile = Schema.userProfiles.findOne({user: Meteor.userId()})
#  productColumn = checkValidationFileImport(data[0])
#  if _.keys(productColumn).length > 0
#    data = _.without(data, data[0])
#    checkAndAddNewMerchantAndWarehouse(productColumn, data, profile)
#    addMerchantStaff(productColumn, data, profile)
#
