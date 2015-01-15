logics.geraProductManagement = {}
Apps.Gera.productManagementInit = []
Apps.Gera.productManagementReactive = []

Apps.Gera.productManagementReactive.push (scope) ->
  if productId = Session.get("mySession")?.currentGeraProductManagementSelection
    Session.set('geraProductManagementCurrentProduct', Schema.buildInProducts.findOne productId )

  if productGroupId =  Session.get("mySession")?.currentGeraProductManagementSelectionProductGroup
    productGroup = Schema.buildInProductUnits.findOne({_id: productGroupId, buildIn: true})
    Session.set("currentGeraProductManagementSelectionProductGroup", productGroup)

  if productUnitId = Session.get("geraProductManagementUnitEditingRowId")
    Session.set("geraProductManagementUnitEditingRow", Schema.buildInProductUnits.findOne productUnitId )
