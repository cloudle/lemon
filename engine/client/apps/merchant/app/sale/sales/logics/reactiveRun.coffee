Apps.Merchant.salesReactiveRun.push (scope) ->
  if Session.get("myProfile")
    scope.managedSalesProductList = []
    products = []; cursorProduct = Schema.products.find({merchant: Session.get("myProfile").currentMerchant})
    Helpers.searchProduct(cursorProduct, products)

    if Session.get("salesCurrentProductSearchFilter")?.length > 0
      salesProductList = []
      salesProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("salesCurrentProductSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item?.name
        unsignedName.indexOf(unsignedTerm) > -1 || item.productCode?.indexOf(unsignedTerm) > -1
      Helpers.searchProductUnit(product, scope.managedSalesProductList) for product in salesProductList

    else
      if Session.get('currentImportDistributor')?.builtIn?.length > 0
        products = []; cursorProduct = Schema.products.find({_id: $in: Session.get('currentImportDistributor').builtIn})
        Helpers.searchProduct(cursorProduct, products)

      groupedProducts = _.groupBy products, (product) -> product.name.substr(0, 1).toLowerCase() if product.name
      for key, childs of groupedProducts
        productList = []
        Helpers.searchProductUnit(product, productList) for product in childs
        scope.managedSalesProductList.push {key: key, childs: productList}

      scope.managedSalesProductList = _.sortBy(scope.managedSalesProductList, (num)-> num.key)


    if Session.get("salesCurrentProductSearchFilter")?.trim().length > 1 and scope.managedSalesProductList.length is 0
      Session.set("salesCurrentProductCreationMode", true)
    else
      Session.set("salesCurrentProductCreationMode", false)
