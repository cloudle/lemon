logics.inventoryManager = {}
Apps.Merchant.inventoryManagerInit = []

Apps.Merchant.inventoryManagerInit.push (scope) ->
  Session.setDefault('showCreateNewInventory', true)
  Session.setDefault('allowCreateNewInventory', false)

  logics.inventoryManager.availableMerchants = Schema.merchants.find({
    $or:[
      {_id   : Session.get('myProfile').parentMerchant}
      {parent: Session.get('myProfile').parentMerchant}]
  })


logics.inventoryManager.reactiveRun = ->
  if Session.get('myProfile') and Session.get('mySession')
    if currentMerchant = Schema.merchants.findOne(Session.get('mySession').currentMerchant)
      logics.inventoryManager.availableWarehouses = Schema.warehouses.find({merchant: currentMerchant._id})
      if !Schema.warehouses.findOne({_id: Session.get('mySession').currentWarehouse, merchant: currentMerchant._id})
        UserSession.set('currentWarehouse', logics.inventoryManager.availableWarehouses.fetch()[0]._id)
    else
      UserSession.set('currentMerchant', Session.get('myProfile').currentMerchant)
      UserSession.set('currentWarehouse', Session.get('myProfile').currentWarehouse)

    logics.inventoryManager.currentWarehouse = Schema.warehouses.findOne(Session.get('mySession').currentWarehouse)
    #  Apps.MerchantSubscriber.subscribe('currentInventory', Session.get('mySession').currentWarehouse)
    logics.inventoryManager.currentInventory = Schema.inventories.findOne(logics.inventoryManager.currentWarehouse.inventory)
    logics.inventoryManager.inventoryDetails = Schema.inventoryDetails.find({inventory: logics.inventoryManager.currentWarehouse.inventory})
    logics.inventoryManager.productDetails = Schema.productDetails.find({warehouse: Session.get('mySession').currentWarehouse})



  if logics.inventoryManager.currentWarehouse?.checkingInventory || !Session.get('allowCreateNewInventory')
    logics.inventoryManager.allowCreate = 'btn-default disabled'
  else logics.inventoryManager.allowCreate = 'btn-success'

  if logics.inventoryManager.currentWarehouse?.checkingInventory
    logics.inventoryManager.showCreate = "display: none"
  else logics.inventoryManager.showCreate = ""

  if logics.inventoryManager.currentInventory
    logics.inventoryManager.showDestroy = ""
  else logics.inventoryManager.showDestroy = "display: none"

  if logics.inventoryManager.currentWarehouse?.checkingInventory is true
    logics.inventoryManager.showDescription = "display: none"
  else logics.inventoryManager.showDescription = ""

  if logics.inventoryManager.currentInventory and logics.inventoryManager.inventoryDetails?.count() > 0
    logics.inventoryManager.showSubmit = ""
    for detail in logics.inventoryManager.inventoryDetails.fetch()
      if detail.lock == false || detail.submit == false || detail.success == true
        logics.inventoryManager.showSubmit = "display: none"
  else
    logics.inventoryManager.showSubmit = "display: none"




