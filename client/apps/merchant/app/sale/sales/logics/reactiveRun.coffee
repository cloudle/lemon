Apps.Merchant.salesReactiveRun.push (scope) ->
  if Session.get("myProfile")
    products = scope.currentAllProductsInWarehouse?.fetch()
    scope.managedSalesProductList = []
    if Session.get("salesCurrentProductSearchFilter")?.length > 0
      scope.managedSalesProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("salesCurrentProductSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1 || item.productCode?.indexOf(unsignedTerm) > -1
    else
      if Session.get('currentImportDistributor')?.builtIn?.length > 0
        products = Schema.products.find({_id: $in: Session.get('currentImportDistributor').builtIn}).fetch()
      groupedProducts = _.groupBy products, (product) -> product.name.substr(0, 1).toLowerCase()
      for key, childs of groupedProducts
        for item in childs
          productUnits = Schema.productUnits.find({product: item._id}).fetch()
          if productUnits.length > 0
            for unit in productUnits
              unit.name = item.name
              unit.basicUnit = unit.unit
              childs.push unit

        scope.managedSalesProductList.push {key: key, childs: childs}
      scope.managedSalesProductList = _.sortBy(scope.managedSalesProductList, (num)-> num.key)




    if Session.get("salesCurrentProductSearchFilter")?.trim().length > 1 and scope.managedSalesProductList.length is 0
      Session.set("salesCurrentProductCreationMode", true)
    else
      Session.set("salesCurrentProductCreationMode", false)
