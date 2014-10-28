Meteor.publish 'orderDetails', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  historyOrders = Schema.orders.find({
    creator   : myProfile.user
    merchant  : myProfile.currentMerchant
    warehouse : myProfile.currentWarehouse
  }).fetch()

  Schema.orderDetails.find({order: {$in:_.pluck(historyOrders, '_id')}})

Schema.orderDetails.allow
  insert: -> true
  update: -> true
  remove: -> true