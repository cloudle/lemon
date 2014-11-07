logics.deliveryManager = {}
Apps.Merchant.deliveryManagerInit = []

Apps.Merchant.deliveryManagerInit.push (scope) ->
  Session.setDefault('deliveryFilter', 'working')


logics.deliveryManager.reactiveRun = ->
  if Session.get('myProfile') && Session.get('deliveryFilter')
    option =
      merchant: Session.get('myProfile').currentMerchant
      warehouse: Session.get('myProfile').currentWarehouse
    switch Session.get('deliveryFilter')
      when "selected" then deliveryFilter = {status: 1}
      when "working" then deliveryFilter = {status: {$in: [2,3,4,5,6,8,9]}}
      when "done" then deliveryFilter = {status: {$in: [7,10]}}
    logics.deliveryManager.availableDeliveries = Schema.deliveries.find({$and:[option,deliveryFilter]})