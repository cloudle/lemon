Apps.Gera.productManagementReactive.push (scope) ->
  if Session.get("myProfile")
    buildInProducts = Schema.buildInProducts.find().fetch()
    scope.managedBuildInProductList = []
    if Session.get("geraProductManagementSearchFilter")?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get("geraProductManagementSearchFilter")

      for product in buildInProducts
        unsignedName = Helpers.RemoveVnSigns product.name
        scope.managedBuildInProductList.push product if unsignedName.indexOf(unsignedSearch) > -1

    else
      groupedProducts = _.groupBy buildInProducts, (product) -> product.name.substr(0, 1).toLowerCase()
      scope.managedBuildInProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedBuildInProductList = _.sortBy(scope.managedBuildInProductList, (num)-> num.key)


    if Session.get("geraProductManagementSearchFilter")?.trim().length > 1
      if scope.managedBuildInProductList.length > 0
        productNameLists = _.pluck(scope.managedBuildInProductList, 'name')
        Session.set("geraProductManagementCreationMode", !_.contains(productNameLists, Session.get("geraProductManagementSearchFilter").trim()))
      else
        Session.set("geraProductManagementCreationMode", true)
    else
      Session.set("geraProductManagementCreationMode", false)