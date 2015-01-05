Apps.Merchant.distributorReturnReactiveRun.push (scope) ->
  if Session.get("currentDistributorReturn")
    salesProductList = []
    scope.managedReturnProductList = []
    products = Schema.products.find().fetch()
    if Session.get("distributorReturnSearchFilter")?.length > 0
      salesProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("distributorReturnSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1 || item.productCode?.indexOf(unsignedTerm) > -1
    else salesProductList = products

    for product in salesProductList
      scope.managedReturnProductList.push {product: product}
      Schema.productUnits.find({product: product._id}).forEach((unit)-> scope.managedReturnProductList.push {product: product, unit: unit})
  else
    scope.managedReturnProductList = []