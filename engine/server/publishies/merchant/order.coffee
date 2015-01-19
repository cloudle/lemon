Meteor.publish 'myOrderHistory', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  historyOrders = Schema.orders.find({
    creator   : myProfile.user
    merchant  : myProfile.currentMerchant
    warehouse : myProfile.currentWarehouse
  })

  if historyOrders.count() is 0
    orderId = Order.createdNewBy(null, myProfile)
    mySession = Schema.userSessions.findOne({user: @userId})
    Schema.userSessions.update(mySession._id, {$set: {currentOrder: orderId}})
    #Search for new added order!
    historyOrders = Schema.orders.find({
      creator   : myProfile.user
      merchant  : myProfile.currentMerchant
      warehouse : myProfile.currentWarehouse
      status    : 0
    })

  historyOrders

#  historyOrderDetails = Schema.orderDetails.find({order: {$in:_.pluck(historyOrders.fetch(), '_id')}})
#  [historyOrders, historyOrderDetails]

#Meteor.publishComposite 'orderAndDetails', (orderId) ->
#  userId = @userId
#  find: ->
#    currentOrder = Schema.orders.findOne(orderId)
#    return [] if !userId or currentOrder?.creator isnt userId
#    Schema.orders.find { _id: orderId }
#  children: [
#    find: (order) -> Schema.orderDetails.find {order: order._id}
#  ]

Meteor.publish 'orderDetails', (orderId) ->
  currentOrder = Schema.orders.findOne(orderId)
  return [] if !@userId or currentOrder?.creator isnt @userId
  Schema.orderDetails.find {order: orderId}

Schema.orders.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.orderDetails.allow
  insert: -> true
  update: -> true
  remove: -> true