Apps.Merchant.distributorReturnReactiveRun.push (scope) ->
  if Session.get("currentDistributorReturn")
    scope.managedReturnProductList = []
    products = []; salesProductList = []
    Helpers.searchProduct(Schema.products.find(), products)

    if Session.get("distributorReturnSearchFilter")?.length > 0
      salesProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("distributorReturnSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item?.name
        unsignedName.indexOf(unsignedTerm) > -1 || item.productCode?.indexOf(unsignedTerm) > -1
    else salesProductList = products
    Helpers.searchProductUnit(product, scope.managedReturnProductList) for product in salesProductList
  else
    scope.managedReturnProductList = []