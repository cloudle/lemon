Apps.Merchant.productManagementReactive.push (scope) ->
  if profile = Session.get("myProfile")
    scope.managedBranchProductList = []
    scope.managedMerchantProductList = []
    scope.managedGeraProductList = []

    scope.branchProductList = []
    scope.merchantProductList = []
    if branchProfile = Schema.branchProfiles.findOne({merchant: profile.currentMerchant})
      branchProductListId = branchProfile.productList ? []
      cursorProduct = Schema.products.find({merchant: Session.get("myProfile").currentMerchant})
      Helpers.searchBranchProduct(cursorProduct, branchProductListId, scope.branchProductList, scope.merchantProductList)

    if Session.get("productManagementSearchFilter")?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get("productManagementSearchFilter")

      for branchProduct in scope.branchProductList
        unsignedName = Helpers.RemoveVnSigns branchProduct.name
        scope.managedBranchProductList.push branchProduct if unsignedName.indexOf(unsignedSearch) > -1

      for merchantProduct in scope.merchantProductList
        unsignedName = Helpers.RemoveVnSigns merchantProduct.name
        scope.managedMerchantProductList.push merchantProduct if unsignedName.indexOf(unsignedSearch) > -1

    else
      groupedProducts = _.groupBy scope.branchProductList, (product) -> product.name.substr(0, 1).toLowerCase() if product.name
      scope.managedBranchProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedBranchProductList = _.sortBy(scope.managedBranchProductList, (num)-> num.key)


    if Session.get("productManagementSearchFilter")?.trim().length > 1
      if scope.managedBranchProductList.length + scope.managedMerchantProductList > 0
        productNameLists = _.pluck(scope.managedBranchProductList, 'name')
        Session.set("productManagementCreationMode", !_.contains(productNameLists, Session.get("productManagementSearchFilter").trim()))
      else
        Session.set("productManagementCreationMode", true)
    else
      Session.set("productManagementCreationMode", false)