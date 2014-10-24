calculateDepositAndDebitByProduct = (order, orderUpdate)->
  if order.currentDeposit == order.finalPrice
    orderUpdate.currentDeposit = orderUpdate.finalPrice

  if order.currentDeposit > orderUpdate.finalPrice
    orderUpdate.currentDeposit = order.currentDeposit

  if order.currentDeposit < orderUpdate.finalPrice
    orderUpdate.currentDeposit = orderUpdate.finalPrice

  orderUpdate.deposit = orderUpdate.finalPrice
  orderUpdate.debit = 0
  orderUpdate

calculateDepositAndDebitByBill = (order, orderUpdate)->
  if order.currentDeposit >= orderUpdate.finalPrice
    orderUpdate.paymentMethod = 0
    orderUpdate.deposit = orderUpdate.finalPrice
    orderUpdate.debit = 0
  else
    orderUpdate.deposit = order.currentDeposit
    orderUpdate.debit = orderUpdate.finalPrice - order.currentDeposit
  orderUpdate

calculateOrderDeposit= (order, orderOptionDefault)->
  switch order.paymentMethod
    when 0 then calculateDepositAndDebitByProduct(order, orderOptionDefault) #Tính theo từng sp
    when 1 then calculateDepositAndDebitByBill(order, orderOptionDefault) #Tính theo tổng bill

calculateDefaultOrder = (order, orderDetails)->
  orderUpdate =
    saleCount       :0
    discountCash    :0
    discountPercent :0
    totalPrice      :0

  for detail in orderDetails
    orderUpdate.totalPrice += detail.quality * detail.price
    orderUpdate.saleCount += detail.quality
    if order.billDiscount
      orderUpdate.discountCash = orderUpdate.discountCash
    else
      orderUpdate.discountCash += detail.discountCash
  orderUpdate.discountPercent = orderUpdate.discountCash/orderUpdate.totalPrice*100
  orderUpdate.finalPrice      = orderUpdate.totalPrice - orderUpdate.discountCash
  orderUpdate

updateOrderByOrderDetail = (order, orderDetails)->
  orderOptionDefault = calculateDefaultOrder(order, orderDetails)
  updateOrder = calculateOrderDeposit(order ,orderOptionDefault)
  Schema.orders.update order._id, $set: updateOrder

updateOrderByOrderDetailEmpty = (order)->
  updateOrder =
    saleCount       : 0
    discountCash    : 0
    discountPercent : 0
    totalPrice      : 0
    finalPrice      : 0
    paymentMethod   : 0
    currentDeposit  : 0
    deposit         : 0
    debit           : 0

  Schema.orders.update order._id, $set: updateOrder

logics.sales.reCalculateOrder = (order) ->
  zone.run =>
    orderDetails = Schema.orderDetails.find({order: order._id}).fetch()
    if orderDetails.length > 0
      updateOrderByOrderDetail(order, orderDetails)
    else
      updateOrderByOrderDetailEmpty(order)





