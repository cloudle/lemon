logics.import = {}
Apps.Merchant.importInit = []
Apps.Merchant.importReload = []
Apps.Merchant.importReactive = []

Apps.Merchant.importReactive.push (scope) ->
  if Session.get('mySession') and Session.get('myProfile')
    scope.currentImport = Import.findBy(
      Session.get('mySession').currentImport
      Session.get('myProfile').currentWarehouse
      Session.get('myProfile').currentMerchant
    )

  if currentImport = scope.currentImport
    Session.set('currentImport', scope.currentImport)
    Meteor.subscribe('importDetails', scope.currentImport._id)

    Session.set('importCurrentProduct', Schema.products.findOne scope.currentImport.currentProduct)
    scope.currentImportDetails = ImportDetail.findBy(scope.currentImport._id)

    scope.hidePriceSale = scope.currentImport.currentPrice > 0
    scope.showCreateDetail = !currentImport.submitted
    scope.showEdit   = currentImport.submitted
    permission = Role.hasPermission(Session.get('myProfile')._id, Apps.Merchant.Permissions.su.key)
    scope.showSubmit = currentImport.distributor and scope.currentImportDetails.count() > 0 and !currentImport.submitted and !permission
    scope.showFinish = currentImport.distributor and scope.currentImportDetails.count() > 0 and !scope.showSubmit




  if currentImport = scope.currentImport
    $("[name=debitCash]").val(currentImport.debit)
    $("[name=depositCash]").val(currentImport.deposit)

  if Session.get("currentImport")?.submitted is true
    Session.set("importEditingRowId")
    Session.set("importEditingRow")

  if Session.get("importEditingRowId")
    Session.set("importEditingRow", Schema.importDetails.findOne(Session.get("importEditingRowId")))

  if Session.get("importEditingRow")
    $("[name=editImportQuality]").val(Session.get("importEditingRow").importQuality)


#    if Session.get('currentImport')
#      $("[name=currentProductQuality]").val(Session.get('currentImport').currentQuality)
#      $("[name=currentProductPrice]").val(Session.get('currentImport').currentImportPrice)
#    else
#      $("[name=currentProductQuality]").val('')
#      $("[name=currentProductPrice]").val('')
#
#    if Session.get('importCurrentProduct')
#      $("[name=currentProductName]").val(Session.get('importCurrentProduct').name)
#      $("[name=currentProductSkulls]").val(Session.get('importCurrentProduct').skulls)
#    else
#      $("[name=currentProductName]").val('')
#      $("[name=currentProductSkulls]").val('')
