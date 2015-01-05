Apps.Merchant.importReactive.push (scope) ->
  if Session.get("myProfile")
    products = Schema.products.find({merchant: Session.get("myProfile").currentMerchant}).fetch()
    scope.managedImportProductList = []
    if Session.get("importManagementSearchFilter")?.length > 0
      importProductList = []
      importProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("importManagementSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1

      for product in importProductList
        scope.managedImportProductList.push {product: product}
        Schema.productUnits.find({product: product._id}).forEach((unit)-> scope.managedImportProductList.push {product: product, unit: unit})

    else
      if Session.get('currentImportDistributor')?.builtIn?.length > 0
        products = Schema.products.find({_id: $in: Session.get('currentImportDistributor').builtIn}).fetch()
      groupedProducts = _.groupBy products, (product) -> product.name.substr(0, 1).toLowerCase()
      for key, childs of groupedProducts
        productList = []
        for product in childs
          productList.push {product: product}
          Schema.productUnits.find({product: product._id}).forEach((unit)-> productList.push {product: product, unit: unit})
        scope.managedImportProductList.push {key: key, childs: productList}
      scope.managedImportProductList = _.sortBy(scope.managedImportProductList, (num)-> num.key)

    if Session.get("importManagementSearchFilter")?.trim().length > 1
      if scope.managedImportProductList.length > 0
        productNameLists = _.pluck(scope.managedImportProductList, 'name')
        Session.set("importCreationMode", !_.contains(productNameLists, Session.get("importManagementSearchFilter").trim()))
      else
        Session.set("importCreationMode", true)
    else
      Session.set("importCreationMode", false)

