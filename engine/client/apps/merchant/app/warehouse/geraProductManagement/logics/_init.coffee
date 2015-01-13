#logics.geraProductManagement = {}
#Apps.Merchant.geraProductManagementInit = []
#Apps.Merchant.geraProductManagementReactive = []
#
#Apps.Merchant.geraProductManagementReactive.push (scope) ->
##  if productId = Session.get("mySession")?.currentgeraProductManagementSelection
##    Session.set("geraProductManagementCurrentProduct", Schema.products.findOne(productId))
##
##  if Session.get("geraProductManagementUnitEditingRowId")
##    Session.set("geraProductManagementUnitEditingRow", Schema.productUnits.findOne(Session.get("geraProductManagementUnitEditingRowId")))
##
##  if Session.get("geraProductManagementDetailEditingRowId")
##    Session.set("geraProductManagementDetailEditingRow", Schema.productDetails.findOne(Session.get("geraProductManagementDetailEditingRowId")))
#
#
