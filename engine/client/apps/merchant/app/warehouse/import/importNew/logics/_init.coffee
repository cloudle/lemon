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

  if distributorId = Session.get('currentImport')?.distributor
    if !Session.get('currentImportDistributor') || Session.get('currentImportDistributor')._id != distributorId
      Session.set 'currentImportDistributor', Schema.distributors.findOne(distributorId)
  else
    Session.set 'currentImportDistributor'

  if partnerId = Session.get('currentImport')?.partner
    if !Session.get('currentImportPartner') || Session.get('currentImportPartner')._id != partnerId
      Session.set 'currentImportPartner', Schema.partners.findOne(partnerId)
  else
    Session.set 'currentImportPartner'


  if Session.get("currentImport")?.submitted is true
    Session.set("importEditingRowId"); Session.set("importEditingRow")

  if Session.get("importEditingRowId")
    Session.set("importEditingRow", Schema.importDetails.findOne(Session.get("importEditingRowId")))