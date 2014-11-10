logics.importHistory = {}
Apps.Merchant.importHistoryInit = []
Apps.Merchant.importHistoryReactiveRun = []

Apps.Merchant.importHistoryInit.push (scope) ->
  date = new Date();
  firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
  lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
  Session.set('importHistoryFilterStartDate', firstDay)
  Session.set('importHistoryFilterToDate', lastDay)

  if scope.currentMerchant = Schema.merchants.findOne(Session.get('mySession').currentImportMerchant)
    if !scope.currentWarehouse = Schema.warehouses.findOne({_id:Session.get('mySession').currentImportWarehouse, merchant: Session.get('mySession').currentImportWarehouse})
      scope.currentWarehouse = Schema.warehouses.findOne({isRoot: true, merchant: Session.get('mySession').currentImportMerchant})
  else
    scope.currentMerchant  = Schema.merchants.findOne(Session.get('myProfile').currentMerchant)
    scope.currentWarehouse = Schema.warehouses.findOne(Session.get('myProfile').currentWarehouse)
    option =
      currentImportMerchant : Session.get('myProfile').currentMerchant
      currentImportWarehouse: Session.get('myProfile').currentWarehouse
    Schema.userSessions.update Session.get('mySession')._id, $set: option

  scope.availableMerchants  = Schema.merchants.find({})
  scope.availableWarehouses = Schema.warehouses.find({merchant: scope.currentMerchant._id})


Apps.Merchant.importHistoryReactiveRun.push (scope) ->
  if Session.get('mySession') and scope.currentMerchant and scope.currentWarehouse
    if Session.get('mySession').currentImportMerchant != scope.currentMerchant._id
      Session.set('currentImportMerchant', Schema.merchants.findOne(scope.currentMerchant._id))
      scope.currentWarehouse = Schema.warehouses.findOne({isRoot: true, merchant: scope.currentWarehouse._id})

    if Session.get('mySession').currentImportMerchant != scope.currentWarehouse._id
      Session.set('currentImportWarehouse', Schema.warehouses.findOne(scope.currentWarehouse._id))

  if scope.currentWarehouse
    scope.availableWarehouses = Schema.warehouses.find({merchant: scope.currentWarehouse.merchant})

  if Session.get('currentImportWarehouse') and Session.get('importHistoryFilterStartDate') and Session.get('importHistoryFilterToDate')
    scope.importHistorys = Schema.imports.find({$and: [
      {warehouse: Session.get('currentImportWarehouse')._id, submitted: true}
      {'version.createdAt': {$gt: Session.get('importHistoryFilterStartDate')}}
      {'version.createdAt': {$lt: Session.get('importHistoryFilterToDate')}}
    ]}, {sort: {'version.createdAt': -1}})

  if Session.get('currentImportHistory')
    scope.currentImportHistoryDetail = Schema.importDetails.find {import: Session.get('currentImportHistory')._id}