splitName = (fullText) ->
  if fullText.indexOf("(") > 0
    namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
    basicUnitPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    return { name: namePart, basicUnit: basicUnitPart }
  else
    return { name: fullText }

Apps.Merchant.productManagementInit.push (scope) ->
  scope.editProduct = (template) ->
    product = Session.get("productManagementCurrentProduct")
    branchProduct = Session.get("productManagementBranchProductSummary")
    if product and branchProduct
      newName  = template.ui.$productName.val()
      newPrice = template.ui.$productPrice.inputmask('unmaskedvalue')
      newImportPrice = template.ui.$importPrice.inputmask('unmaskedvalue')
      newProductCode = template.ui.$productCode.val()
      return if newName.replace("(", "").replace(")", "").trim().length < 2

      productEdit = {$set: {}, $unset: {}}; productEdit.$set = splitName(newName)
      branchProductEdit = {$set: {}, $unset: {}}

      if newPrice.length > 0
        if branchProduct.parentMerchant is branchProduct.merchant and branchProduct.price isnt Number(newPrice)
          productEdit.$set.price = newPrice
        if branchProduct.price is Number(newPrice) then branchProductEdit.$unset.price = ""
        else branchProductEdit.$set.price = newPrice
      if newImportPrice.length > 0
        if branchProduct.parentMerchant is branchProduct.merchant and branchProduct.importPrice isnt Number(newImportPrice)
          productEdit.$set.importPrice = newImportPrice
        if branchProduct.importPrice is Number(newImportPrice) then branchProductEdit.$unset.importPrice = ""
        else branchProductEdit.$set.importPrice = newImportPrice

      buildInProduct = Session.get("productManagementBuildInProduct")
      if product.buildInProduct
        buildInProduct = if product.buildInProduct is buildInProduct._id then buildInProduct else Schema.buildInProducts.findOne(product.buildInProduct)
        delete productEdit.$set.basicUnit; productEdit.$unset.basicUnit = ""; productEdit.$unset.productCode = ""
        (delete productEdit.$set.name; productEdit.$unset.name = "") if buildInProduct.name is productEdit.$set.name
      else
        delete productEdit.$set.basicUnit if Schema.productUnits.findOne({product: product._id})
        if newProductCode.length > 0 and newProductCode isnt product.productCode
          productEdit.$set.productCode = newProductCode
          barcodeFound = Schema.products.findOne {productCode: newProductCode, merchant: product.merchant}
        if productEdit.$set.name.length > 0
          if productEdit.$set.name is product.name then delete productEdit.$set.name
          else productFound = Schema.products.findOne {name: productEdit.$set.name, merchant: product.merchant}


      if productEdit.$set.name and productEdit.$set.name.length is 0
        template.ui.$productName.notify("Tên sản phẩn không thể để trống.", {position: "right"})
      else if productFound and productFound._id isnt product._id
        template.ui.$productName.notify("Tên sản phẩm đã tồn tại.", {position: "right"})
      else if barcodeFound and barcodeFound._id isnt product._id
        template.ui.$productCode.notify("Mã sản phẩm đã tồn tại.", {position: "right"})
      else
        delete productEdit.$set if _.keys(productEdit.$set).length is 0
        delete productEdit.$unset if _.keys(productEdit.$unset).length is 0
        if _.keys(productEdit).length > 0
          Schema.products.update product._id, productEdit, (error, result)->
            if error then console.log error

        delete branchProductEdit.$set if _.keys(branchProductEdit.$set).length is 0
        delete branchProductEdit.$unset if _.keys(branchProductEdit.$unset).length is 0
        if _.keys(branchProductEdit).length > 0
          Schema.branchProductSummaries.update branchProduct._id, branchProductEdit, (error, result)->
            if error then console.log error

        console.log productEdit
        console.log branchProductEdit


        productName = (
          if product.buildInProduct
            if productEdit.$set?.name then productEdit.$set.name else product.name ? buildInProduct.name
          else
            productEdit.$set?.name ? product.name
        )
        template.ui.$productName.val productName
        Session.set("productManagementShowEditCommand", false)


  scope.createProduct = (template)->
    fullText    = Session.get("productManagementSearchFilter")
    nameOptions = splitName(fullText)

    product =
      parentMerchant: Session.get('myProfile').parentMerchant
      merchant      : Session.get('myProfile').currentMerchant
      warehouse     : Session.get('myProfile').currentWarehouse
      creator       : Session.get('myProfile').user
      name          : nameOptions.name
      styles        : Helpers.RandomColor()
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
      Meteor.call('createBranchProductSummaryBy', productId)
      MetroSummary.updateMetroSummaryBy(['product'])

  scope.updateProductUnit = (productUnit, template)->
    if productUnit.buildInProductUnit
      unit    = template.ui.$unit.val()
      barcode = template.ui.$barcode.val()

      if productUnit.allowDelete
        conversionQuality = Math.abs(Helpers.Number(template.ui.$conversionQuality.inputmask('unmaskedvalue')))
        conversionQuality = 1 if conversionQuality < 1

    price       = Math.abs(Helpers.Number(template.ui.$price.inputmask('unmaskedvalue')))
    importPrice = Math.abs(Helpers.Number(template.ui.$importPrice.inputmask('unmaskedvalue')))


    unitOption =
      unit        : unit
      productCode : barcode
      price       : price
      importPrice : importPrice
    unitOption.conversionQuality = conversionQuality if conversionQuality
    Schema.productUnits.update productUnit._id, $set: unitOption

  scope.updateBasicProductDetail = (productDetailId, template)->
    if productDetail = Schema.productDetails.findOne(productDetailId)
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
        importPrice       : if unitImportPrice is 0 then 0 else unitImportPrice/productDetail.conversionQuality
        importQuality     : unitQuality * productDetail.conversionQuality
        availableQuality  : unitQuality * productDetail.conversionQuality
        inStockQuality    : unitQuality * productDetail.conversionQuality
      detailOption.expire = expireDate if expireDate
      Schema.productDetails.update productDetail._id, $set: detailOption

      productUpdate =
        totalQuality    : detailOption.importQuality - productDetail.importQuality
        availableQuality: detailOption.availableQuality - productDetail.availableQuality
        inStockQuality  : detailOption.inStockQuality - productDetail.inStockQuality
      Schema.branchProductSummaries.update productDetail.branchProduct, $inc:productUpdate
      Schema.products.update productDetail.product, $inc: productUpdate

  #    productOption = {totalQuality: 0, availableQuality: 0, inStockQuality: 0}
  #    Schema.productDetails.find({product: productDetail.product}).forEach(
  #      (detail)->
  #        productOption.totalQuality     += detail.importQuality
  #        productOption.availableQuality += detail.importQuality
  #        productOption.inStockQuality   += detail.importQuality
  #    )
  #    Schema.branchProductSummaries.update productDetail.branchProduct, $set: productOption

  #    metroSummary = Schema.metroSummaries.findOne({merchant: Session.get('myProfile').currentMerchant})
  #    Schema.metroSummaries.update metroSummary._id, $inc:{
  #      stockProductCount: unitQuality * productDetail.conversionQuality - productDetail.importQuality
  #      availableProductCount: unitQuality * productDetail.conversionQuality - productDetail.importQuality
  #    }


