logics.transportHistory = {}
Apps.Merchant.transportHistoryInit = []
Apps.Merchant.transportHistoryReactiveRun = []

Apps.Merchant.transportHistoryInit.push (scope) ->
  date = new Date();
  firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
  lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
  Session.set('transportHistoryFilterStartDate', firstDay)
  Session.set('transportHistoryFilterToDate', lastDay)

  scope.availableMerchants = Schema.merchants.find({
    $or:[
      {_id   : Session.get('myProfile').parentMerchant}
      {parent: Session.get('myProfile').parentMerchant}]
  })


Apps.Merchant.transportHistoryReactiveRun.push (scope) ->
  if Session.get('mySession') and Session.get('myProfile')
    if scope.currentMerchant = Schema.merchants.findOne(Session.get('mySession').currentTransportBranchSelection)
      scope.currentWarehouse = Schema.warehouses.findOne({_id: Session.get('mySession').currentTransportWarehouseSelection, merchant: scope.currentMerchant._id})
      if !scope.currentWarehouse
        scope.currentWarehouse = Schema.warehouses.findOne({isRoot: true, merchant: scope.currentMerchant._id})
        UserSession.set('currentTransportWarehouseSelection', scope.currentWarehouse?._id ? 'skyReset')
    else
      scope.currentMerchant  = Schema.merchants.findOne(Session.get('myProfile').currentMerchant)
      scope.currentWarehouse = Schema.merchants.findOne(Session.get('myProfile').currentWarehouse)
      UserSession.set('currentTransportBranchSelection', Session.get('myProfile').currentMerchant)
      UserSession.set('currentTransportWarehouseSelection', Session.get('myProfile').currentWarehouse)

  scope.availableWarehouses  = Schema.warehouses.find({merchant: scope.currentMerchant._id}) if scope.currentMerchant

  if Session.get('mySession')?.currentTransportWarehouseSelection and Session.get('transportHistoryFilterStartDate') and Session.get('transportHistoryFilterToDate')
    scope.availableTransports = Schema.inventories.find({$and: [
        {warehouse: Session.get('mySession').currentTransportWarehouseSelection}
        {'version.createdAt': {$gt: Session.get('transportHistoryFilterStartDate')}}
        {'version.createdAt': {$lt: Session.get('transportHistoryFilterToDate')}}
      ]}, {sort: {'version.createdAt': -1}})

  if Session.get('currentTransportHistory')
    scope.currentTransportDetailHistory      = Schema.transportDetails.find {transport: Session.get('currentTransportHistory')._id, lostQuality: {$gt: 0}}
    scope.currentTransportProductLostHistory = Schema.productLosts.find {transport: Session.get('currentTransportHistory')._id}





