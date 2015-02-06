Apps.Merchant.customerReturnReactiveRun.push (scope) ->
  if currentCustomer = Session.get("customerReturnCurrentCustomer")
    scope.managedReturnProductList = []
    products = []; salesProductList = []
    productListId = currentCustomer.builtIn ? []
    Helpers.searchProduct(Schema.products.find({_id:{$in:productListId}}), products)
    if Session.get("customerReturnSearchFilter")?.length > 0
      salesProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("customerReturnSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item?.name
        unsignedName.indexOf(unsignedTerm) > -1 || item.productCode?.indexOf(unsignedTerm) > -1
    else salesProductList = products
    Helpers.searchProductUnit(product, scope.managedReturnProductList) for product in salesProductList
  else
    scope.managedReturnProductList = []