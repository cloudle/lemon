Apps.Merchant.salesInit.push ->
  logics.sales.createNewOrderAndSelected = ->
    if Session.get('myProfile') and buyer = Schema.customers.findOne(logics.sales.currentOrder.buyer)
      UserSession.set('currentOrder', newOrder._id) if newOrder = Order.createdNewBy(buyer, Session.get('myProfile'))
    else
      console.log buyer, Session.get('myProfile')
      return undefined