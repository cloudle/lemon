logics.staffManager = {}
Apps.Merchant.staffManagerInit = []
Apps.Merchant.staffManagerReactiveRun = []


Apps.Merchant.staffManagerInit.push (scope) ->
  scope.availableMerchants = Schema.merchants.find({
    $or:[
      {_id   : Session.get('myProfile').parentMerchant}
      {parent: Session.get('myProfile').parentMerchant}]
  })

Apps.Merchant.staffManagerReactiveRun.push (scope) ->


