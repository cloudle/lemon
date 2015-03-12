logics.import.createImportAndSelected = ->
  if newImport = Import.createdNewBy(null, null, null, Session.get('myProfile'))
    Session.set('currentImport', newImport)
    UserSession.set('currentImport', newImport._id)
    return newImport

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
    Schema.importDetails.find({import: currentImport._id}).forEach((detail)-> Schema.importDetails.remove detail._id)
    Schema.imports.remove currentImport._id
    logics.import.myHistory.count()
  else
    -1

Apps.Merchant.importInit.push (scope) ->
  logics.import.tabOptions =
    source: logics.import.myHistory
    currentSource: 'currentImport'
    caption: 'tabDisplay'
    key: '_id'
    createAction  : -> logics.import.createImportAndSelected()
    destroyAction : (instance) -> destroyImportAndDetail(instance._id)
    navigateAction: (instance) ->
      UserSession.set('currentImport', instance._id)
      Session.set('currentImport', instance)
      Session.set("currentImportDescription", instance.description)






