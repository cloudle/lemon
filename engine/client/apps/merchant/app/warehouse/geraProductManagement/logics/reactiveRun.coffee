#Apps.Merchant.productManagementReactive.push (scope) ->
#  if Session.get("myProfile")
#    products = Schema.products.find({merchant: Session.get("myProfile").currentMerchant}).fetch()
#    scope.managedProductList = []
#    if Session.get("productManagementSearchFilter")?.length > 0
#      unsignedSearch = Helpers.RemoveVnSigns Session.get("productManagementSearchFilter")
#
#      for product in products
#        unsignedName = Helpers.RemoveVnSigns product.name
#        scope.managedProductList.push product if unsignedName.indexOf(unsignedSearch) > -1
#
#    else
#      groupedProducts = _.groupBy products, (product) -> product.name.substr(0, 1).toLowerCase()
#      scope.managedProductList.push {key: key, childs: childs} for key, childs of groupedProducts
#      scope.managedProductList = _.sortBy(scope.managedProductList, (num)-> num.key)
#
#
#    if Session.get("productManagementSearchFilter")?.trim().length > 1
#      if scope.managedProductList.length > 0
#        productNameLists = _.pluck(scope.managedProductList, 'name')
#        Session.set("productManagementCreationMode", !_.contains(productNameLists, Session.get("productManagementSearchFilter").trim()))
#      else
#        Session.set("productManagementCreationMode", true)
#    else
#      Session.set("productManagementCreationMode", false)