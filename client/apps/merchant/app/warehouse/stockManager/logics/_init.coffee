logics.stockManager = {}
Apps.Merchant.stockManagerInit = []

Apps.Merchant.stockManagerInit.push (scope) ->
  logics.stockManager.availableProducts = Schema.products.find({warehouse: Session.get('myProfile').currentWarehouse})
logics.stockManager.reactiveRun = ->




