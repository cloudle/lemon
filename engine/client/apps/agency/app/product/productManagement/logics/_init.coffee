logics.agencyProductManagement = {}
Apps.Agency.agencyProductManagementInit = []
Apps.Agency.agencyProductManagementReactive = []

Apps.Agency.agencyProductManagementReactive.push (scope) ->
  merchantId = Session.get("myProfile")?.currentMerchant
  productId  = Session.get("mySession")?.currentProductManagementSelection
  if productId and merchantId
    product = Schema.products.findOne(productId)
    branchProduct = Schema.branchProductSummaries.findOne({merchant: merchantId, product: productId})
    if product and branchProduct
      Session.set("agencyProductManagementBranchProductSummary", branchProduct)
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
        Session.set("agencyProductManagementBuildInProduct", buildInProduct)
        product.productCode = buildInProduct.productCode
        product.basicUnit   = buildInProduct.basicUnit

        product.name  = buildInProduct.name if !product.name
        product.image = buildInProduct.image if !product.image
        product.description = buildInProduct.description if !product.description
      Session.set("agencyProductManagementCurrentProduct", product)

  if Session.get("agencyProductManagementUnitEditingRowId")
    if productUnit = Schema.productUnits.findOne Session.get("agencyProductManagementUnitEditingRowId")
      buildInProductUnit = Schema.buildInProductUnits.findOne(productUnit.buildInProductUnit) if productUnit.buildInProductUnit
      if buildInProductUnit
        productUnit.unit              = buildInProductUnit.unit if !productUnit.unit
        productUnit.productCode       = buildInProductUnit.productCode if !productUnit.productCode
        productUnit.conversionQuality = buildInProductUnit.conversionQuality if !productUnit.conversionQuality
      Session.set("agencyProductManagementUnitEditingRow", productUnit)

  if Session.get("agencyProductManagementDetailEditingRowId")
    Session.set("agencyProductManagementDetailEditingRow", Schema.productDetails.findOne(Session.get("agencyProductManagementDetailEditingRowId")))


