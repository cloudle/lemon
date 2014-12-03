Apps.Merchant.stockManagementReactive.push (scope) ->
  if Session.get("myProfile")
    products = Schema.products.find({merchant: Session.get("myProfile").currentMerchant}).fetch()
    scope.managedProductList = []
    if Session.get("stockManagementSearchFilter")?.length > 0
      scope.managedProductList = _.filter products, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("stockManagementSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
    else
      groupedProducts = _.groupBy products, (product) -> product.name.substr(0, 1).toLowerCase()
      console.log groupedProducts
      scope.managedProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedProductList = _.sortBy(scope.managedProductList, (num)-> num.key)


    if Session.get("stockManagementSearchFilter")?.trim().length > 1 and scope.managedProductList.length is 0
      Session.set("stockManagementCreationMode", true)
    else
      Session.set("stockManagementCreationMode", false)