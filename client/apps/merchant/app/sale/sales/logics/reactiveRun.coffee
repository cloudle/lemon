Apps.Merchant.salesReactiveRun.push (scope) ->
  if Session.get("myProfile")
    products = scope.currentAllProductsInWarehouse?.fetch()
    scope.managedSalesProductList = []
    if Session.get("salesCurrentProductSearchFilter")?.length > 0
      scope.managedSalesProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("salesCurrentProductSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1 || item.productCode.indexOf(unsignedTerm) > -1
    else
      if Session.get('currentOrderCustomer')?.builtIn?.length > 0
        products = Schema.products.find({_id: $in: Session.get('currentOrderCustomer').builtIn}).fetch()
      groupedProducts = _.groupBy products, (product) -> product.name.substr(0, 1).toLowerCase()
      scope.managedSalesProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedSalesProductList = _.sortBy(scope.managedSalesProductList, (num)-> num.key)

    if Session.get("salesCurrentProductSearchFilter")?.trim().length > 1 and scope.managedSalesProductList.length is 0
      Session.set("salesCurrentProductCreationMode", true)
    else
      Session.set("salesCurrentProductCreationMode", false)
