Apps.Agency.agencyProductManagementReactive.push (scope) ->
  merchantId = Session.get("myProfile")?.currentMerchant
  productId  = Session.get("mySession")?[scope.agencyProductManagementCurrentProductId]
  if productId and merchantId
    product = Schema.products.findOne(productId)
    branchProductFound = Schema.branchProductSummaries.findOne({merchant: merchantId, product: productId})
    if product and branchProductFound
      Session.set(scope.agencyProductManagementBranchProduct, branchProductFound)
      product.price       = branchProductFound.price if branchProductFound.price
      product.importPrice = branchProductFound.importPrice if branchProductFound.importPrice

      product.salesQuality     = branchProductFound.salesQuality
      product.totalQuality     = branchProductFound.totalQuality
      product.availableQuality = branchProductFound.availableQuality
      product.inStockQuality   = branchProductFound.inStockQuality
      product.returnQualityByCustomer    = branchProductFound.returnQualityByCustomer
      product.returnQualityByDistributor = branchProductFound.returnQualityByDistributor

      buildInProductFound = Schema.buildInProducts.findOne(product.buildInProduct) if product.buildInProduct
      if buildInProductFound
        Session.set(scope.agencyProductManagementBuildInProduct, buildInProductFound)
        product.productCode = buildInProductFound.productCode
        product.basicUnit = buildInProductFound.basicUnit

        product.name = buildInProductFound.name if !product.name
        product.image = buildInProductFound.image if !product.image
        product.description = buildInProductFound.description if !product.description
      Session.set(scope.agencyProductManagementCurrentProduct, product)

  if productUnit = Schema.productUnits.findOne(Session.get(scope.agencyProductManagementUnitEditingRowId))
    buildInProductUnit = Schema.buildInProductUnits.findOne(productUnit.buildInProductUnit) if productUnit.buildInProductUnit
    if buildInProductUnit
      productUnit.unit              = buildInProductUnit.unit if !productUnit.unit
      productUnit.productCode       = buildInProductUnit.productCode if !productUnit.productCode
      productUnit.conversionQuality = buildInProductUnit.conversionQuality if !productUnit.conversionQuality
    Session.set(scope.agencyProductManagementUnitEditingRow, productUnit)

  if detailEditingRowId = Session.get(scope.agencyProductManagementDetailEditingRowId)
    Session.set(scope.agencyProductManagementDetailEditingRow, Schema.productDetails.findOne(detailEditingRowId))

  if Session.get("myProfile")
    scope.managedAgencyProductList = []
    scope.productList = []
    cursorProduct = Schema.products.find({merchant: Session.get("myProfile").currentMerchant})
    Helpers.searchProduct(cursorProduct, scope.productList)

    productSearchFilter = Session.get(scope.agencyProductManagementProductSearchFilter)
    productSearchFilter = productSearchFilter.trim() if productSearchFilter?.length > 0

    if productSearchFilter?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get(scope.agencyProductManagementProductSearchFilter)

      for product in scope.productList
        unsignedName = Helpers.RemoveVnSigns product.name
        scope.managedAgencyProductList.push product if unsignedName.indexOf(unsignedSearch) > -1

    else
      groupedProducts = _.groupBy scope.productList, (product) -> product.name.substr(0, 1).toLowerCase() if product.name
      scope.managedAgencyProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedAgencyProductList = _.sortBy(scope.managedAgencyProductList, (num)-> num.key)

    if productSearchFilter?.length > 1
      if scope.managedAgencyProductList.length > 0
        productNameLists = _.pluck(scope.managedAgencyProductList, 'name')
        Session.set(scope.agencyProductManagementProductCreationMode, !_.contains(productNameLists, Session.get(scope.agencyProductManagementProductSearchFilter).trim()))
      else
        Session.set(scope.agencyProductManagementProductCreationMode, true)
    else
      Session.set(scope.agencyProductManagementProductCreationMode, false)

