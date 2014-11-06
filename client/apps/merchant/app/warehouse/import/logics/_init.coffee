logics.import = {}
Apps.Merchant.importInit = []
Apps.Merchant.importReload = []

Apps.Merchant.importInit.push (scope) ->
  logics.import.availableProducts  = Product.insideWarehouse(Session.get('myProfile').currentWarehouse)
  logics.import.availableSkulls    = Skull.insideMerchant(Session.get('myProfile').parentMerchant)
  logics.import.availableProviders = Provider.insideMerchant(Session.get('myProfile').parentMerchant)
  logics.import.branchProviders    = Provider.insideBranch(Session.get('myProfile').currentMerchant)
  logics.import.myHistory          = Import.myHistory(Session.get('myProfile').user, Session.get('myProfile').currentWarehouse, Session.get('myProfile').currentMerchant)
  logics.import.myCreateProduct    = Product.canDeleteByMeInside()
  logics.import.myCreateProvider   = Provider.canDeleteByMe()


logics.import.reactiveRun = ->
  if Session.get('mySession') and Session.get('myProfile')
    logics.import.currentImport = Import.findBy(Session.get('mySession').currentImport,
                                                Session.get('myProfile').currentWarehouse,
                                                Session.get('myProfile').currentMerchant)
  if currentImport = logics.import.currentImport
    Session.set('currentImport', logics.import.currentImport)
    Apps.MerchantSubscriber.subscribe('importDetails', logics.import.currentImport._id)
    logics.import.currentImportDetails = ImportDetail.findBy(logics.import.currentImport._id)

    logics.import.showCreateDetail = !currentImport.submitted
    logics.import.showEdit   = currentImport.submitted
    permission = Role.hasPermission(Session.get('myProfile').user, Apps.Merchant.Permissions.su.key)
    logics.import.showSubmit = logics.import.currentImportDetails.count() > 0 and !currentImport.submitted and !permission
    logics.import.showFinish = logics.import.currentImportDetails.count() > 0 and !logics.import.showSubmit






