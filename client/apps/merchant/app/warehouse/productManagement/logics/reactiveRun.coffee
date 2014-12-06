Apps.Merchant.productManagementReactive.push (scope) ->
  if Session.get("myProfile")
    products = Schema.products.find({merchant: Session.get("myProfile").currentMerchant}).fetch()
    scope.managedProductList = []
    if Session.get("productManagementSearchFilter")?.length > 0
      scope.managedProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("productManagementSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
    else
      groupedProducts = _.groupBy products, (product) -> product.name.substr(0, 1).toLowerCase()
      scope.managedProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedProductList = _.sortBy(scope.managedProductList, (num)-> num.key)


    if Session.get("productManagementSearchFilter")?.trim().length > 1 and scope.managedProductList.length is 0
      Session.set("productManagementCreationMode", true)
    else
      Session.set("productManagementCreationMode", false)