logics.deliveryManager = {}
Apps.Merchant.deliveryManagerInit = []

Apps.Merchant.deliveryManagerInit.push (scope) ->
  Session.setDefault('deliveryFilter', 'working')