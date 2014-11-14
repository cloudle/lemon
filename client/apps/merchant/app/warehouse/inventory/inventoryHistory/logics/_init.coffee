logics.inventoryHistory = {}
Apps.Merchant.inventoryHistoryInit = []
Apps.Merchant.inventoryHistoryReactiveRun = []

Apps.Merchant.inventoryHistoryInit.push (scope) ->
  date = new Date();
  firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
  lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
  Session.set('inventoryHistoryFilterStartDate', firstDay)
  Session.set('inventoryHistoryFilterToDate', lastDay)

  scope.availableMerchants = Schema.merchants.find({
    $or:[
      {_id   : Session.get('myProfile').parentMerchant}
      {parent: Session.get('myProfile').parentMerchant}]
  })


Apps.Merchant.inventoryHistoryReactiveRun.push (scope) ->
  if Session.get('mySession') and Session.get('myProfile')
    if scope.currentMerchant = Schema.merchants.findOne(Session.get('mySession').currentInventoryBranchSelection)
      scope.currentWarehouse = Schema.warehouses.findOne({_id: Session.get('mySession').currentInventoryWarehouseSelection, merchant: scope.currentMerchant._id})
      if !scope.currentWarehouse
        scope.currentWarehouse = Schema.warehouses.findOne({isRoot: true, merchant: scope.currentMerchant._id})
        UserSession.set('currentInventoryWarehouseSelection', scope.currentWarehouse?._id ? 'skyReset')
    else
      scope.currentMerchant  = Schema.merchants.findOne(Session.get('myProfile').currentMerchant)
      scope.currentWarehouse = Schema.merchants.findOne(Session.get('myProfile').currentWarehouse)
      UserSession.set('currentInventoryBranchSelection', Session.get('myProfile').currentMerchant)
      UserSession.set('currentInventoryWarehouseSelection', Session.get('myProfile').currentWarehouse)

  scope.availableWarehouses  = Schema.warehouses.find({merchant: scope.currentMerchant._id}) if scope.currentMerchant

  if Session.get('mySession')?.currentInventoryWarehouseSelection and Session.get('inventoryHistoryFilterStartDate') and Session.get('inventoryHistoryFilterToDate')
    scope.availableInventories = Inventory.findHistory(
      Session.get('inventoryHistoryFilterStartDate')
      Session.get('inventoryHistoryFilterToDate')
      Session.get('mySession').currentInventoryWarehouseSelection
    )

  if Session.get('currentInventoryHistory')
    scope.currentInventoryDetailHistory      = Schema.inventoryDetails.find {inventory: Session.get('currentInventoryHistory')._id, lostQuality: {$gt: 0}}
    scope.currentInventoryProductLostHistory = Schema.productLosts.find {inventory: Session.get('currentInventoryHistory')._id}





