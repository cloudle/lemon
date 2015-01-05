randomBarcode = -> (Math.floor(Math.random() * 100000000000) + 89 *100000000000).toString()
checkValidationFileImport = (column)->
  data = []
  data.push(item.trim()) for item in column
  console.log data
  productColumn = {}
  productColumn.barcode        = data.indexOf("ma san pham (barcode)")
  productColumn.name           = data.indexOf("ten san pham")
  productColumn.skull          = data.indexOf("quy cach")
  productColumn.quality        = data.indexOf("so luong")
  productColumn.price          = data.indexOf("gia nhap")
  productColumn.priceSale      = data.indexOf("gia ban")
  productColumn.productionDate = data.indexOf("ngay san xuat")
  productColumn.expireDate     = data.indexOf("ngay het han")
  productColumn.providerName   = data.indexOf("nha cung cap")

  console.log productColumn
  for key, value of productColumn
    return productColumn = {} if value is -1

  productColumn

findProvider = (providerName, profile)->
  if providerName
    provider = Schema.providers.findOne({parentMerchant: profile.parentMerchant, name: providerName})
    if provider then provider._id else Provider.createNew(providerName)

findProduct = (barcode, name, skull, price, priceSale, profile)->
  option =
    merchant    : profile.currentMerchant
    warehouse   : profile.currentWarehouse
    productCode : if barcode then barcode else randomBarcode()
    skulls      : skull

  salePrice = if priceSale then priceSale else price
  if barcode
    product = Schema.products.findOne(option)
    if product then product._id else Product.createNew(option.productCode, name, [skull], salePrice, profile.currentWarehouse)
  else
    while Schema.products.findOne(option) then option.productCode = randomBarcode()
    Product.createNew(option.productCode, name, [skull], salePrice, profile.currentWarehouse)

addDetailInImport = (column, data, imports, profile)->
  for item in data
    providerId = findProvider(item[column.providerName], profile)
    productId = findProduct(item[column.barcode], item[column.name], item[column.skull], item[column.price], item[column.priceSale], profile)

    importDetail =
      merchant      : imports.merchant
      warehouse     : imports.warehouse
      import        : imports._id
      product       : productId
      provider      : providerId if providerId
      importQuality : item[column.quality]
      importPrice   : item[column.price]
      salePrice     : item[column.priceSale]
      totalPrice    : item[column.quality] * item[column.price]
      productionDate: moment(item[column.productionDate], "DD/MM/YYYY")._d
      expire        : moment(item[column.expireDate], "DD/MM/YYYY")._d

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
      Schema.importDetails.insert importDetail, (error, result) -> console.log error if error

reCalculateImport = (importId)->
  importDetails = Schema.importDetails.find({import: importId._id}).fetch()
  totalPrice = 0
  if importDetails.length > 0
    for detail in importDetails
      totalPrice += (detail.importQuality * detail.importPrice)
      option = {totalPrice: totalPrice, deposit: totalPrice, debit: 0}
  else option = {totalPrice: 0, deposit: 0, debit: 0}
  Schema.imports.update importId, $set: option


currentImportFind = (profile)->
  importId = Schema.userSessions.findOne({user: profile.user})?.currentImport
  if !currentImport = Schema.imports.findOne(importId) then currentImport = logics.import.createImportAndSelected()
  currentImport

Apps.Merchant.importInit.push (scope) ->
  scope.importFileProductCSV = (data)->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    currentImport = currentImportFind(profile)
    productColumn = checkValidationFileImport(data[0])
    if _.keys(productColumn).length > 0
      data = _.without(data, data[0])
      addDetailInImport(productColumn, data, currentImport, profile)
      reCalculateImport(currentImport._id)
      logics.import.reCalculateImport(currentImport._id)

