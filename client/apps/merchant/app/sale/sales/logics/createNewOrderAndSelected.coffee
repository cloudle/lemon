Apps.Merchant.salesInit.push ->
  logics.sales.createNewOrderAndSelected = ->
    buyer = Schema.customers.findOne(logics.sales.currentOrder.buyer)
    if Session.get('myProfile') and buyer
      newOrderId = Order.createdNewBy(buyer, Session.get('myProfile'))
      logics.sales.selectOrder(newOrderId) if newOrderId
    else
      console.log buyer, Session.get('myProfile')