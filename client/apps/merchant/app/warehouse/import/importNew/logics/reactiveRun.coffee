Apps.Merchant.importReactive.push (scope) ->
  if Session.get("myProfile")
    products = Schema.products.find({merchant: Session.get("myProfile").currentMerchant}).fetch()
    scope.managedImportProductList = []
    if Session.get("importManagementSearchFilter")?.length > 0
      scope.managedImportProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("importManagementSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
    else
      groupedProducts = _.groupBy products, (product) -> product.name.substr(0, 1).toLowerCase()
      scope.managedImportProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedImportProductList = _.sortBy(scope.managedImportProductList, (num)-> num.key)

    if Session.get("importManagementSearchFilter")?.trim().length > 1
      if scope.managedImportProductList.length > 0
        productNameLists = _.pluck(scope.managedImportProductList, 'name')
        Session.set("importCreationMode", !_.contains(productNameLists, Session.get("importManagementSearchFilter").trim()))
      else
        Session.set("importCreationMode", true)
    else
      Session.set("importCreationMode", false)

