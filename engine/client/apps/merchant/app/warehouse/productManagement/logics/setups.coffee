splitName = (fullText) ->
  if fullText.indexOf("(") > 0
    namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
    basicUnitPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    return { name: namePart, basicUnit: basicUnitPart }
  else
    return { name: fullText }

Apps.Merchant.productManagementInit.push (scope) ->
  scope.editProduct = (template) ->
    if product = Session.get("productManagementCurrentProduct")
      newName  = template.ui.$productName.val()
      newPrice = template.ui.$productPrice.inputmask('unmaskedvalue')
      newProductCode = template.ui.$productCode.val()
      return if newName.replace("(", "").replace(")", "").trim().length < 2
      editOptions = splitName(newName)
      editOptions.price = newPrice if newPrice.length > 0
      editOptions.productCode = newProductCode if newProductCode.length > 0

      productFound = Schema.products.findOne {name: editOptions.name, merchant: product.merchant} if editOptions.name.length > 0
      barcodeFound = Schema.products.findOne {productCode: newProductCode, merchant: product.merchant} if newProductCode.length > 0

      if editOptions.name.length is 0
        template.ui.$productName.notify("Tên sản phẩn không thể để trống.", {position: "right"})
      else if productFound and productFound._id isnt product._id
        template.ui.$productName.notify("Tên sản phẩm đã tồn tại.", {position: "right"})
      else if barcodeFound and barcodeFound._id isnt product._id
        template.ui.$productCode.notify("Mã sản phẩm đã tồn tại.", {position: "right"})
      else
        if Schema.productUnits.findOne({product: product._id})
          delete editOptions.basicUnit
          console.log editOptions
          Schema.products.update product._id, {$set: editOptions}, (error, result) -> if error then console.log error
        else
          Schema.products.update product._id, {$set: editOptions}, (error, result) -> if error then console.log error

        template.ui.$productName.val editOptions.name
        Session.set("productManagementShowEditCommand", false)


  scope.createProduct = (template)->
    fullText    = Session.get("productManagementSearchFilter")
    nameOptions = splitName(fullText)

    product =
      merchant  : Session.get('myProfile').currentMerchant
      warehouse : Session.get('myProfile').currentWarehouse
      creator   : Session.get('myProfile').user
      name      : nameOptions.name
      styles    : Helpers.RandomColor()
    product.basicUnit = nameOptions.basicUnit if nameOptions.basicUnit

    existedQuery = {name: product.name, merchant: Session.get('myProfile').currentMerchant}
#    existedQuery.basicUnit = product.basicUnit if product.basicUnit

    if Schema.products.findOne(existedQuery)
      template.ui.$searchFilter.notify("Sản phẩm đã tồn tại.", {position: "bottom"})
    else
      while true
        randomBarcode = Helpers.randomBarcode()
        existedQuery.productCode = randomBarcode
        if !Schema.products.findOne(existedQuery)
          product.productCode = randomBarcode
          productId = Schema.products.insert  product, (error, result) -> console.log error if error
          UserSession.set('currentProductManagementSelection', productId)
          Meteor.subscribe('productManagementData', productId)
          template.ui.$searchFilter.val(''); Session.set("productManagementSearchFilter", "")
          break
      MetroSummary.updateMetroSummaryBy(['product'])

  scope.updateProductUnit = (productUnit, template)->
    unit                  = template.ui.$unit.val()
    barcode               = template.ui.$barcode.val()
    priceText             = template.ui.$price.inputmask('unmaskedvalue')
    importPriceText       = template.ui.$importPrice.inputmask('unmaskedvalue')
    conversionQualityText = template.ui.$conversionQuality.inputmask('unmaskedvalue')

    price       = Math.abs(Helpers.Number(priceText))
    importPrice = Math.abs(Helpers.Number(importPriceText))

    if productUnit.allowDelete
      conversionQuality = Math.abs(Helpers.Number(conversionQualityText))
      conversionQuality = 1 if conversionQuality < 1

    unitOption =
      unit        : unit
      productCode : barcode
      price       : price
      importPrice : importPrice
    unitOption.conversionQuality = conversionQuality if conversionQuality
    Schema.productUnits.update productUnit._id, $set: unitOption

  scope.updateBasicProductDetail = (productDetail, template)->
    $paidDate = $("[name='expireDate']").inputmask('unmaskedvalue')
    isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid()
    if isValidDate then expireDate = moment($paidDate, 'DDMMYYYY')._d

    unitQuality = Helpers.Number(template.ui.$unitQuality.inputmask('unmaskedvalue'))
    unitQuality = 1 if unitQuality < 0

    unitImportPrice = Helpers.Number(template.ui.$importPrice.inputmask('unmaskedvalue'))
    unitImportPrice = 0 if unitImportPrice < 0

    detailOption =
      unitQuality       : unitQuality
      unitPrice         : unitImportPrice
      importPrice       : unitImportPrice/productDetail.conversionQuality
      importQuality     : unitQuality * productDetail.conversionQuality
      availableQuality  : unitQuality * productDetail.conversionQuality
      inStockQuality    : unitQuality * productDetail.conversionQuality
    detailOption.expire = expireDate if expireDate
    Schema.productDetails.update productDetail._id, $set: detailOption

    productOption = {totalQuality: 0, availableQuality: 0, inStockQuality: 0}
    Schema.productDetails.find({product: productDetail.product}).forEach(
      (detail)->
        productOption.totalQuality     += detail.importQuality
        productOption.availableQuality += detail.importQuality
        productOption.inStockQuality   += detail.importQuality
    )
    Schema.products.update productDetail.product, $set: productOption

#    metroSummary = Schema.metroSummaries.findOne({merchant: Session.get('myProfile').currentMerchant})
#    Schema.metroSummaries.update metroSummary._id, $inc:{
#      stockProductCount: unitQuality * productDetail.conversionQuality - productDetail.importQuality
#      availableProductCount: unitQuality * productDetail.conversionQuality - productDetail.importQuality
#    }


