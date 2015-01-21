logics.productManagement = {}
Apps.Merchant.productManagementInit = []
Apps.Merchant.productManagementReactive = []

Apps.Merchant.productManagementReactive.push (scope) ->
  merchantId = Session.get("myProfile")?.currentMerchant
  productId  = Session.get("mySession")?.currentProductManagementSelection
  if productId and merchantId
    product = Schema.products.findOne(productId)
    branchProduct = Schema.branchProductSummaries.findOne({merchant: merchantId, product: productId})
    if product and branchProduct
      Session.set("productManagementBranchProductSummary", branchProduct)
      product.price       = branchProduct.price if branchProduct.price
      product.importPrice = branchProduct.importPrice if branchProduct.importPrice

      product.salesQuality     = branchProduct.salesQuality
      product.totalQuality     = branchProduct.totalQuality
      product.availableQuality = branchProduct.availableQuality
      product.inStockQuality   = branchProduct.inStockQuality
      product.returnQualityByCustomer    = branchProduct.returnQualityByCustomer
      product.returnQualityByDistributor = branchProduct.returnQualityByDistributor

      buildInProduct = Schema.buildInProducts.findOne(product.buildInProduct) if product.buildInProduct
      if buildInProduct
        Session.set("productManagementBuildInProduct", buildInProduct)
        product.productCode = buildInProduct.productCode
        product.basicUnit = buildInProduct.basicUnit

        product.name = buildInProduct.name if !product.name
        product.image = buildInProduct.image if !product.image
        product.description = buildInProduct.description if !product.description
      Session.set("productManagementCurrentProduct", product)

  if Session.get("productManagementUnitEditingRowId")
    Session.set("productManagementUnitEditingRow", Schema.productUnits.findOne(Session.get("productManagementUnitEditingRowId")))

  if Session.get("productManagementDetailEditingRowId")
    Session.set("productManagementDetailEditingRow", Schema.productDetails.findOne(Session.get("productManagementDetailEditingRowId")))


