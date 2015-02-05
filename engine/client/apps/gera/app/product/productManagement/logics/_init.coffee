logics.geraProductManagement = {}
Apps.Gera.productManagementInit = []
Apps.Gera.productManagementReactive = []

Apps.Gera.productManagementReactive.push (scope) ->
  if productId = Session.get("mySession")?.currentGeraProductManagementSelection
    buildInProduct = Schema.buildInProducts.findOne productId
    Session.set 'geraProductManagementCurrentProduct', buildInProduct

#  if productGroupId =  Session.get("mySession")?.currentGeraProductManagementSelectionProductGroup
#    productGroup = Schema.buildInProductUnits.findOne({_id: productGroupId, buildIn: true})
#    Session.set("currentGeraProductManagementSelectionProductGroup", productGroup)

  if productUnitId = Session.get("geraProductManagementUnitEditingRowId")
    buildInProductUnit = Schema.buildInProductUnits.findOne productUnitId
    Session.set "geraProductManagementUnitEditingRow", buildInProductUnit

  merchantList = []
  merchantRegisters = Session.get('geraProductManagementCurrentProduct')?.merchantRegister
  merchantList = Schema.merchants.find({ _id: {$in:merchantRegisters} }).fetch() if merchantRegisters?.length > 0
  Session.set "geraProductManagementMerchantList", merchantList
