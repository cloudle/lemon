logics.productManagement = {}
Apps.Merchant.productManagementInit = []
Apps.Merchant.productManagementInitSubscriber = []
Apps.Merchant.productManagementReactive = []


Apps.Merchant.productManagementInitSubscriber.push (scope) ->
  lemon.dependencies.resolve('productManagements')
  Session.set("productManagementSearchFilter", "")

Apps.Merchant.productManagementReactive.push (scope) ->
  merchantId = Session.get("myProfile")?.currentMerchant
  productId  = Session.get("mySession")?.currentProductManagementSelection

  if productId and !Session.get("productManagementCurrentProduct")
    Meteor.subscribe('productManagementData', productId)
    Session.set("productManagementCurrentProduct", Schema.products.findOne(productId))

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
      product.basicDetailModeEnabled     = branchProduct.basicDetailModeEnabled

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
    if productUnit = Schema.productUnits.findOne Session.get("productManagementUnitEditingRowId")
      buildInProductUnit = Schema.buildInProductUnits.findOne(productUnit.buildInProductUnit) if productUnit.buildInProductUnit
      if buildInProductUnit
        productUnit.unit              = buildInProductUnit.unit if !productUnit.unit
        productUnit.productCode       = buildInProductUnit.productCode if !productUnit.productCode
        productUnit.conversionQuality = buildInProductUnit.conversionQuality if !productUnit.conversionQuality
      Session.set("productManagementUnitEditingRow", productUnit)

  if Session.get("productManagementDetailEditingRowId")
    Session.set("productManagementDetailEditingRow", Schema.productDetails.findOne(Session.get("productManagementDetailEditingRowId")))


