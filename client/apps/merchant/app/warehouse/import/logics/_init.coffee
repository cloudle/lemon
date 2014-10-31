logics.import = {}
Apps.Merchant.importInit = []
Apps.Merchant.importReload = []

Apps.Merchant.importInit.push (scope) ->
  logics.import.availableProducts  = Product.insideWarehouse(Session.get('myProfile').currentWarehouse)
  logics.import.availableSkulls    = Skull.insideMerchant(Session.get('myProfile').parentMerchant)
  logics.import.availableProviders = Provider.insideMerchant(Session.get('myProfile').parentMerchant)
  logics.import.branchProviders    = Provider.insideBranch(Session.get('myProfile').currentMerchant)
  logics.import.myHistory          = Import.myHistory(Session.get('myProfile').user, Session.get('myProfile').currentWarehouse, Session.get('myProfile').currentMerchant)



logics.import.reactiveRun = ->
  if Session.get('mySession') and Session.get('myProfile')
    logics.import.currentImport = Import.findBy(Session.get('mySession').currentImport, Session.get('myProfile').currentWarehouse, Session.get('myProfile').currentMerchant)
  if logics.import.currentImport
    Session.set('currentImport', logics.import.currentImport)
    Apps.MerchantSubscriber.subscribe('importDetails', logics.import.currentImport._id)

    logics.import.currentImportDetails = ImportDetail.findBy(logics.import.currentImport._id)


#    logics.import.currentWarehouse = Warehouse.findBy(mySession.currentWarehouse) if mySession = Session.get('mySession')









