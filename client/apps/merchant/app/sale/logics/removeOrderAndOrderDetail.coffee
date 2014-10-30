Apps.Merchant.salesInit.push ->
  logics.sales.selectOrder = (orderId)->  UserSession.set('currentOrder', orderId)

Apps.Merchant.salesInit.push ->
  logics.sales.removeOrderAndOrderDetail = (orderId)->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    order = Schema.orders.findOne({
      _id       : orderId
      creator   : userProfile.user
      merchant  : userProfile.currentMerchant
      warehouse : userProfile.currentWarehouse})
    if order
      for orderDetail in Schema.orderDetails.find({order: order._id}).fetch()
        Schema.orderDetails.remove(orderDetail._id)
      Schema.orders.remove(order._id)

      Schema.orders.find({
        creator   : userProfile.user
        merchant  : userProfile.currentMerchant
        warehouse : userProfile.currentWarehouse}).count()
    else
      -1




