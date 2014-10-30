logics.sales.createNewOrderAndSelected = ->
  buyer = logics.sales.currentOrderBuyer
  newOrderId = Order.createdNewBy(buyer, logics.sales.myProfile)
  logics.sales.selectOrder(newOrderId) if newOrderId




