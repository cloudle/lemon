Meteor.publish 'myOrderHistoryAndDetail', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  historyOrders = Schema.orders.find({
    creator   : myProfile.user
    merchant  : myProfile.currentMerchant
    warehouse : myProfile.currentWarehouse
  })

  historyOrderDetails = Schema.orderDetails.find({order: {$in:_.pluck(historyOrders.fetch(), '_id')}})

  [historyOrders, historyOrderDetails]

Schema.orders.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.orderDetails.allow
  insert: -> true
  update: -> true
  remove: -> true