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

    if Session.get("importManagementSearchFilter")?.trim().length > 1 and scope.managedImportProductList.length is 0
      Session.set("importCreationMode", true)
    else
      Session.set("importCreationMode", false)

    if Session.get('currentImport')
      $("[name=currentProductQuality]").val(Session.get('currentImport').currentQuality)
      $("[name=currentProductPrice]").val(Session.get('currentImport').currentImportPrice)
    else
      $("[name=currentProductQuality]").val('')
      $("[name=currentProductPrice]").val('')

    if Session.get('importCurrentProduct')
      $("[name=currentProductName]").val(Session.get('importCurrentProduct').name)
      $("[name=currentProductSkulls]").val(Session.get('importCurrentProduct').skulls)
    else
      $("[name=currentProductName]").val('')
      $("[name=currentProductSkulls]").val('')

