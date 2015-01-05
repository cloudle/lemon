Apps.Merchant.salesInit.push ->
  logics.sales.createNewOrderAndSelected = ->
    if Session.get('myProfile') and buyer = Schema.customers.findOne(Session.get('currentOrder').buyer)
      if newOrder = Order.createdNewBy(buyer, Session.get('myProfile'))
        Session.set('currentOrder', newOrder)
        UserSession.set('currentOrder', newOrder._id)
    else
      console.log buyer, Session.get('myProfile')
      return undefined