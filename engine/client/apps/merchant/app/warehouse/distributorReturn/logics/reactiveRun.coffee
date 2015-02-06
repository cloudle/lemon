Apps.Merchant.distributorReturnReactiveRun.push (scope) ->
  if currentDistributor = Session.get("distributorReturnCurrentDistributor")
    scope.managedReturnProductList = []
    products = []; salesProductList = []
    productListId = currentDistributor.builtIn ? []
    Helpers.searchProduct(Schema.products.find({_id:{$in:productListId}}), products)

    if Session.get("distributorReturnSearchFilter")?.length > 0
      salesProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("distributorReturnSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item?.name
        unsignedName.indexOf(unsignedTerm) > -1 || item.productCode?.indexOf(unsignedTerm) > -1
    else salesProductList = products
    Helpers.searchProductUnit(product, scope.managedReturnProductList) for product in salesProductList
  else
    scope.managedReturnProductList = []