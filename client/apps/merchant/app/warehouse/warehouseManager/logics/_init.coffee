logics.warehouseManager = {}
Apps.Merchant.warehouseManagerInit = []

Apps.Merchant.warehouseManagerInit.push (scope) ->
  Session.setDefault('allowCreateNewWarehouse', false)
  logics.warehouseManager.availableWarehouses = Schema.warehouses.find({merchant: Session.get('myProfile').currentMerchant})


logics.warehouseManager.reactiveRun = ->
  if Session.get('allowCreateNewWarehouse')
    logics.warehouseManager.allowCreate = 'btn-success'
  else
    logics.warehouseManager.allowCreate = 'btn-default disabled'
