logics.inventoryManager = {}
Apps.Merchant.inventoryManagerInit = []
Apps.Merchant.inventoryReactiveRun = []

Apps.Merchant.inventoryManagerInit.push (scope) ->
  Session.setDefault('showCreateNewInventory', true)
  Session.setDefault('allowCreateNewInventory', false)
  scope.availableMerchants = Schema.merchants.find({
    $or:[
      {_id   : Session.get('myProfile').parentMerchant}
      {parent: Session.get('myProfile').parentMerchant}]
  })


Apps.Merchant.inventoryReactiveRun.push (scope) ->
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

  if scope.currentWarehouse
    scope.availableWarehouses = Schema.warehouses.find({merchant: scope.currentWarehouse.merchant})
    scope.productDetails      = Schema.productDetails.find({warehouse: scope.currentWarehouse._id})

    if scope.currentWarehouse.inventory
      if scope.currentInventory
        if scope.currentInventory._id != scope.currentWarehouse.inventory
          scope.currentInventory = Schema.inventories.findOne(scope.currentWarehouse.inventory)
      else
        scope.currentInventory = Schema.inventories.findOne(scope.currentWarehouse.inventory)
      Meteor.subscribe('inventoryDetailInWarehouse', scope.currentInventory._id)
      scope.inventoryDetails = Schema.inventoryDetails.find({inventory: scope.currentInventory._id})
    else
      scope.currentInventory = null
      scope.inventoryDetails = null


  scope.allowCreate     = if scope.currentWarehouse?.checkingInventory || !Session.get('allowCreateNewInventory') then 'disabled' else ''
  scope.showCreate      = if scope.currentWarehouse?.checkingInventory then "display: none" else ""
  scope.showDescription = if scope.currentWarehouse?.checkingInventory is true then "display: none" else ""
  scope.showDestroy = if scope.currentInventory then "" else "display: none"

  if scope.currentInventory and scope.inventoryDetails?.count() > 0
    scope.showSubmit = ""
    for detail in scope.inventoryDetails.fetch()
      if detail.lock == false || detail.submit == false || detail.success == true
        scope.showSubmit = "display: none"; break
  else scope.showSubmit = "display: none"




