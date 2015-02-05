Apps.Merchant.checkValidSyncProductToGera = (product) ->
  isValid = false
  if product
    isValid = true
    Schema.productUnits.find({product: product._id}).forEach(
      (productUnit) ->
        if productUnit.buildInProduct or !productUnit.unit or !productUnit.productCode or !productUnit.conversionQuality
          isValid = false
        else if productUnit.productCode.length < 11 or productUnit.conversionQuality <= 1
          isValid = false
    )
    if product.buildInProduct or !product.name or !product.productCode or !product.basicUnit
      isValid = false
    else if product.name.length < 1 or product.productCode.length < 11 or product.basicUnit.length < 1
      isValid = false
  isValid

Apps.Agency.currentProductData = (merchantId, productId, sessionBranchProduct, sessionBuildInProduct, sessionCurrentProduct)->
  if productId and merchantId
    product = Schema.products.findOne(productId)
    branchProduct = Schema.branchProductSummaries.findOne({merchant: merchantId, product: productId})
    if product and branchProduct
      Session.set(sessionBranchProduct, branchProduct)
      product.price       = branchProduct.price if branchProduct.price
      product.importPrice = branchProduct.importPrice if branchProduct.importPrice

      product.salesQuality               = branchProduct.salesQuality
      product.totalQuality               = branchProduct.totalQuality
      product.availableQuality           = branchProduct.availableQuality
      product.inStockQuality             = branchProduct.inStockQuality
      product.returnQualityByCustomer    = branchProduct.returnQualityByCustomer
      product.returnQualityByDistributor = branchProduct.returnQualityByDistributor

      buildInProduct = Schema.buildInProducts.findOne(product.buildInProduct) if product.buildInProduct
      if buildInProduct
        Session.set(sessionBuildInProduct, buildInProduct)
        product.productCode = buildInProduct.productCode
        product.basicUnit   = buildInProduct.basicUnit

        product.name  = buildInProduct.name if !product.name
        product.image = buildInProduct.image if !product.image
        product.description = buildInProduct.description if !product.description
      Session.set( sessionCurrentProduct, product)
