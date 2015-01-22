Apps.Merchant.productManagementReactive.push (scope) ->
  if Session.get("myProfile")
    scope.managedProductList = []
    scope.productList = []
    Schema.products.find({merchant: Session.get("myProfile").currentMerchant}).forEach(
      (product) ->
        buildInProduct = Schema.buildInProducts.findOne(product.buildInProduct) if product.buildInProduct
        if buildInProduct
          product.productCode = buildInProduct.productCode
          product.basicUnit = buildInProduct.basicUnit

          product.name  = buildInProduct.name if !product.name
          product.image = buildInProduct.image if !product.image
          product.description = buildInProduct.description if !product.description
        scope.productList.push product
    )

    if Session.get("productManagementSearchFilter")?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get("productManagementSearchFilter")

      for product in scope.productList
        unsignedName = Helpers.RemoveVnSigns product.name
        scope.managedProductList.push product if unsignedName.indexOf(unsignedSearch) > -1

    else
      groupedProducts = _.groupBy scope.productList, (product) -> product.name.substr(0, 1).toLowerCase() if product.name
      scope.managedProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedProductList = _.sortBy(scope.managedProductList, (num)-> num.key)


    if Session.get("productManagementSearchFilter")?.trim().length > 1
      if scope.managedProductList.length > 0
        productNameLists = _.pluck(scope.managedProductList, 'name')
        Session.set("productManagementCreationMode", !_.contains(productNameLists, Session.get("productManagementSearchFilter").trim()))
      else
        Session.set("productManagementCreationMode", true)
    else
      Session.set("productManagementCreationMode", false)