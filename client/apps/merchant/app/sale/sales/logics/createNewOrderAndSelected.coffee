Apps.Merchant.salesInit.push ->
  logics.sales.createNewOrderAndSelected = ->
    buyer = Schema.customers.findOne(logics.sales.currentOrder.buyer)
    newOrderId = Order.createdNewBy(buyer, Session.get('myProfile'))
    logics.sales.selectOrder(newOrderId) if newOrderId