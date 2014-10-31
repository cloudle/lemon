logics.import.createImportAndSelected = ->
  importId = Import.createdNew('01-05-2015', Session.get('myProfile'))
  UserSession.set('currentImport', importId)

destroyImportAndDetail = (importId)->
  currentImport = Schema.imports.findOne(
    {
      _id       : importId
      creator   : Session.get('myProfile').user
      merchant  : Session.get('myProfile').currentMerchant
      warehouse : Session.get('myProfile').currentWarehouse
    }
  )
  if currentImport
    for importDetail in Schema.importDetails.find({import: currentImport._id}).fetch()
      OrderDetail.remove(importDetail._id)
    Import.remove(currentImport._id)

    logics.import.myHistory.count()
  else
    -1

Apps.Merchant.importInit.push (scope) ->
  logics.import.tabOptions =
    source: logics.import.myHistory
    currentSource: 'currentImport'
    caption: 'description'
    key: '_id'
    createAction  : -> logics.import.createImportAndSelected()
    destroyAction : (instance) -> destroyImportAndDetail(instance._id)
    navigateAction: (instance) -> UserSession.set('currentImport', instance._id)






