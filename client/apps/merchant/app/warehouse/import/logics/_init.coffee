logics.import = {}

logics.import.syncCurrentWarehouse = ->
  logics.import.currentWarehouse = Warehouse.findBy(mySession.currentWarehouse) if mySession = Session.get('mySession')

logics.import.syncCurrentImport = ->
  logics.import.currentImport = Import.findBy(mySession.currentImport) if mySession = Session.get('mySession')

logics.import.syncCurrentImportDetails = ->
  if logics.import.currentImport
    logics.import.currentImportDetails = ImportDetail.findBy(logics.import.currentImport._id)

logics.import.syncCurrentProductAndProvider = ->
  if currentImport = logics.sales.currentImport
    logics.import.currentProduct  = Product.findBy(currentImport.currentProduct)
    logics.import.currentProvider = Provider.findBy(currentImport.currentProvider)


#load ca thong tin can thiet cho nhap kho(thong tin san pham, skull, provider)
logics.import.syncImportInfo = ->
  if myProfile = Session.get('myProfile')
    logics.import.productsInWarehouse   = Product.insideWarehouse(myProfile.currentWarehouse)
    logics.import.skulls                = Skull.insideMerchant(myProfile.parentMerchant)
    logics.import.providers             = Provider.insideMerchant(myProfile.parentMerchant)
    logics.import.branchProviders       = Provider.insideBranch(myProfile.currentMerchant)

