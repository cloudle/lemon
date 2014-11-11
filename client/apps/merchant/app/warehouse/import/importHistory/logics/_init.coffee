logics.importHistory = {}
Apps.Merchant.importHistoryInit = []
Apps.Merchant.importHistoryReactiveRun = []

Apps.Merchant.importHistoryInit.push (scope) ->
  date = new Date();
  firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
  lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
  Session.set('importHistoryFilterStartDate', firstDay)
  Session.set('importHistoryFilterToDate', lastDay)

  scope.availableMerchants = Schema.merchants.find({
    $or:[
      {_id   : Session.get('myProfile').parentMerchant}
      {parent: Session.get('myProfile').parentMerchant}]
  })

Apps.Merchant.importHistoryReactiveRun.push (scope) ->
  if Session.get('mySession') and Session.get('myProfile')
    if scope.currentMerchant = Schema.merchants.findOne(Session.get('mySession').currentImportMerchant)
      scope.currentWarehouse = Schema.warehouses.findOne({_id: Session.get('mySession').currentImportWarehouse, merchant: scope.currentMerchant._id})
    else
      scope.currentMerchant  = Schema.merchants.findOne(Session.get('myProfile').currentImportMerchant)
      scope.currentWarehouse = Schema.merchants.findOne(Session.get('myProfile').currentImportWarehouse)
      UserSession.set('currentImportMerchant', Session.get('myProfile').currentMerchant)
      UserSession.set('currentImportWarehouse', Session.get('myProfile').currentWarehouse)

  if scope.currentWarehouse
    scope.availableWarehouses = Schema.warehouses.find({merchant: scope.currentWarehouse.merchant})

  if Session.get('mySession')?.currentImportWarehouse and Session.get('importHistoryFilterStartDate') and Session.get('importHistoryFilterToDate')
    scope.importHistorys = Schema.imports.find({$and: [
      {warehouse: Session.get('mySession').currentImportWarehouse, submitted: true}
      {'version.createdAt': {$gt: Session.get('importHistoryFilterStartDate')}}
      {'version.createdAt': {$lt: Session.get('importHistoryFilterToDate')}}
    ]}, {sort: {'version.createdAt': -1}})

  if Session.get('currentImportHistory')
    scope.currentImportHistoryDetail = Schema.importDetails.find {import: Session.get('currentImportHistory')._id}