Apps.Merchant.importReactive.push (scope) ->
  if Session.get("myProfile")
    products = Schema.products.find({merchant: Session.get("myProfile").currentMerchant}).fetch()
    scope.managedImportProductList = []
    if Session.get("importManagementSearchFilter")?.length > 0
      scope.managedImportProductList = _.filter customers, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("importManagementSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
    else
      groupedProducts = _.groupBy products, (product) -> product.name.split(' ').pop().substr(0, 1).toLowerCase()
      scope.managedImportProductList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedImportProductList = _.sortBy(scope.managedImportProductList, (num)-> num.key)

    if Session.get("importManagementSearchFilter")?.trim().length > 1 and scope.managedImportProductList.length is 0
      Session.set("importManagementCreationMode", true)
    else
      Session.set("importManagementCreationMode", false)
