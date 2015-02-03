@Helpers = {}
Apps.Home = {}
Apps.Merchant = {}
Apps.Gera = {}
Apps.Agency = {}

Helpers.searchProduct = (cursorProduct, products)->
  cursorProduct.forEach(
    (product) ->
      if product.buildInProduct
        if buildInProduct = Schema.buildInProducts.findOne(product.buildInProduct)
          product.productCode = buildInProduct.productCode
          product.basicUnit = buildInProduct.basicUnit

          product.name  = buildInProduct.name if !product.name
          product.image = buildInProduct.image if !product.image
          product.description = buildInProduct.description if !product.description

          products.push product
      else
        products.push product
  )

Helpers.searchProductUnit = (product, productUnits)->
  productUnits.push {product: product}
  Schema.productUnits.find({product: product._id}).forEach(
    (unit)->
      if unit.buildInProductUnit
        buildInProductUnit = Schema.buildInProductUnits.findOne(unit.buildInProductUnit)
        unit.unit = buildInProductUnit.unit if !unit.unit
      productUnits.push {product: product, unit: unit}
  )

#Helpers.searchProductList = (cursorProduct, productList, )->
#  Helpers.searchProduct(cursorProduct, scope.productList)
#  if Session.get("agencyProductManagementSearchFilter")?.length > 0
#    unsignedSearch = Helpers.RemoveVnSigns Session.get("agencyProductManagementSearchFilter")
#
#    for product in scope.productList
#      unsignedName = Helpers.RemoveVnSigns product.name
#      scope.managedAgencyProductList.push product if unsignedName.indexOf(unsignedSearch) > -1
#
#  else
#    groupedProducts = _.groupBy scope.productList, (product) -> product.name.substr(0, 1).toLowerCase() if product.name
#    scope.managedAgencyProductList.push {key: key, childs: childs} for key, childs of groupedProducts
#    scope.managedAgencyProductList = _.sortBy(scope.managedAgencyProductList, (num)-> num.key)
#
#
#  if Session.get("agencyProductManagementSearchFilter")?.trim().length > 1
#    if scope.managedAgencyProductList.length > 0
#      productNameLists = _.pluck(scope.managedAgencyProductList, 'name')
#      Session.set("agencyProductManagementCreationMode", !_.contains(productNameLists, Session.get("agencyProductManagementSearchFilter").trim()))
#    else
#      Session.set("agencyProductManagementCreationMode", true)
#  else
#    Session.set("agencyProductManagementCreationMode", false)