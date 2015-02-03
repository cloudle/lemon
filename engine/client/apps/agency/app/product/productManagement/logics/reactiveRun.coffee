Apps.Agency.agencyProductManagementReactive.push (scope) ->
  if Session.get("myProfile")
    scope.managedAgencyProductList = []
    scope.productList = []
    cursorProduct = Schema.products.find({merchant: Session.get("myProfile").currentMerchant})
    Helpers.searchProduct(cursorProduct, scope.productList)

    if Session.get("agencyProductManagementSearchFilter")?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get("agencyProductManagementSearchFilter")

      for product in scope.productList
        unsignedName = Helpers.RemoveVnSigns product.name
        scope.managedAgencyProductList.push product if unsignedName.indexOf(unsignedSearch) > -1

    else
      groupedProducts = _.groupBy scope.productList, (product) -> product.name.substr(0, 1).toLowerCase() if product.name
      scope.managedAgencyProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedAgencyProductList = _.sortBy(scope.managedAgencyProductList, (num)-> num.key)


    if Session.get("agencyProductManagementSearchFilter")?.trim().length > 1
      if scope.managedAgencyProductList.length > 0
        productNameLists = _.pluck(scope.managedAgencyProductList, 'name')
        Session.set("agencyProductManagementCreationMode", !_.contains(productNameLists, Session.get("agencyProductManagementSearchFilter").trim()))
      else
        Session.set("agencyProductManagementCreationMode", true)
    else
      Session.set("agencyProductManagementCreationMode", false)