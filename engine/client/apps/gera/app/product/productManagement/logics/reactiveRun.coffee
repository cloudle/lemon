Apps.Gera.productManagementReactive.push (scope) ->
  if Session.get("myProfile")
    buildInProducts = Schema.buildInProducts.find().fetch()
    scope.managedProductList = []
    if Session.get("geraProductManagementSearchFilter")?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get("geraProductManagementSearchFilter")

      for product in buildInProducts
        unsignedName = Helpers.RemoveVnSigns product.name
        scope.managedProductList.push product if unsignedName.indexOf(unsignedSearch) > -1

    else
      groupedProducts = _.groupBy buildInProducts, (product) -> product.name.substr(0, 1).toLowerCase()
      scope.managedProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedProductList = _.sortBy(scope.managedProductList, (num)-> num.key)


    if Session.get("geraProductManagementSearchFilter")?.trim().length > 1
      if scope.managedProductList.length > 0
        productNameLists = _.pluck(scope.managedProductList, 'name')
        Session.set("geraProductManagementCreationMode", !_.contains(productNameLists, Session.get("geraProductManagementSearchFilter").trim()))
      else
        Session.set("geraProductManagementCreationMode", true)
    else
      Session.set("geraProductManagementCreationMode", false)