waiting = {status: 1}
delivering = {status: {$in: [2, 3, 4]}}
done = {status: {$in: [5, 8, 6, 9]}}
sortByUpdateDesc = {sort: {'version.createdAt': -1}}

Apps.Merchant.deliveryManagerInit.push (scope) ->
  belongedToThisMerchant = {merchant: Session.get('myProfile').currentMerchant}
  scope.waitingDeliveries = Schema.deliveries.find({$and: [belongedToThisMerchant, waiting]}, sortByUpdateDesc)
  scope.deliveringDeliveries = Schema.deliveries.find({$and: [belongedToThisMerchant, delivering]}, sortByUpdateDesc)
  scope.doneDeliveries = Schema.deliveries.find({$and: [belongedToThisMerchant, done]}, sortByUpdateDesc)