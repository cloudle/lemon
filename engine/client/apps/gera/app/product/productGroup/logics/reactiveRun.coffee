Apps.Gera.geraProductGroupReactive.push (scope) ->
  if Session.get("myProfile")
    buildInProducts = Schema.productGroups.find({buildIn: true}).fetch()
    scope.managedProductGroupList = []
    if Session.get("geraProductGroupSearchFilter")?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get("geraProductGroupSearchFilter")

      for product in buildInProducts
        unsignedName = Helpers.RemoveVnSigns product.name
        scope.managedProductGroupList.push product if unsignedName.indexOf(unsignedSearch) > -1

    else
      groupedProducts = _.groupBy buildInProducts, (product) -> product.name.substr(0, 1).toLowerCase()
      scope.managedProductGroupList.push {key: key, childs: childs} for key, childs of groupedProducts
      scope.managedProductGroupList = _.sortBy(scope.managedProductGroupList, (num)-> num.key)


    if Session.get("geraProductGroupSearchFilter")?.trim().length > 1
      if scope.managedProductGroupList.length > 0
        productNameLists = _.pluck(scope.managedProductGroupList, 'name')
        Session.set("geraProductGroupCreationMode", !_.contains(productNameLists, Session.get("geraProductGroupSearchFilter").trim()))
      else
        Session.set("geraProductGroupCreationMode", true)
    else
      Session.set("geraProductGroupCreationMode", false)