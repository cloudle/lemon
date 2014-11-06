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
  if logics.import.currentImport
    Session.set('currentImport', logics.import.currentImport)
    Apps.MerchantSubscriber.subscribe('importDetails', logics.import.currentImport._id)
    logics.import.currentImportDetails = ImportDetail.findBy(logics.import.currentImport._id)

    if Session.get('currentImport')?.submitted then logics.import.hideAddDetail = "display: none"
    else logics.import.hideAddDetail = ""

    if Session.get('currentImport')?.currentPrice < 0 then logics.import.hidePrice = "display: none"
    else logics.import.hidePrice = ""

    if Session.get('currentImport')?.currentPrice < 0
      logics.import.hideFinishImport = "display: none"
    else logics.import.hideFinishImport = ""

    if Session.get('currentImport')?.currentPrice < 0 then logics.import.hidePrice = "display: none"
    else logics.import.hideSubmitImport = ""
    if Session.get('currentImport')?.submitted is true then logics.import.hideSubmitImport = "display: none"
    else logics.import.hideSubmitImport = ""








