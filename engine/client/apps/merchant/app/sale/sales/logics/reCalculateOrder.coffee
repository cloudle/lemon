calculateDepositAndDebitByProduct = (currentOrder, orderUpdate)->
  if currentOrder.currentDeposit > orderUpdate.finalPrice
    orderUpdate.currentDeposit = currentOrder.currentDeposit
  else
    orderUpdate.currentDeposit = orderUpdate.finalPrice

  orderUpdate.deposit = orderUpdate.finalPrice
  orderUpdate.debit = 0
  orderUpdate

calculateDepositAndDebitByBill = (currentOrder, orderUpdate)->
  if currentOrder.currentDeposit >= orderUpdate.finalPrice
    orderUpdate.paymentMethod = 0
    orderUpdate.deposit = orderUpdate.finalPrice
    orderUpdate.debit = 0
  else
    orderUpdate.deposit = currentOrder.currentDeposit
    orderUpdate.debit = orderUpdate.finalPrice - currentOrder.currentDeposit

  orderUpdate.paymentMethod = 1 if orderUpdate.totalPrice is 0
  orderUpdate

calculateOrderDeposit= (currentOrder, orderOptionDefault)->
  switch currentOrder.paymentMethod
    when 0 then calculateDepositAndDebitByProduct(currentOrder, orderOptionDefault)
    when 1 then calculateDepositAndDebitByBill(currentOrder, orderOptionDefault)

calculateDefaultOrder = (currentOrder, orderDetails)->
  orderUpdate =
    saleCount       :0
    discountCash    :0
    discountPercent :0
    totalPrice      :0

  for detail in orderDetails
    orderUpdate.totalPrice += detail.quality * detail.price
    orderUpdate.saleCount += detail.quality

    if currentOrder.billDiscount then orderUpdate.discountCash = orderUpdate.discountCash
    else orderUpdate.discountCash += detail.discountCash

  if orderUpdate.totalPrice is 0 then orderUpdate.discountPercent = 0
  else orderUpdate.discountPercent = orderUpdate.discountCash/orderUpdate.totalPrice*100

  orderUpdate.finalPrice = orderUpdate.totalPrice - orderUpdate.discountCash
  orderUpdate

updateOrderByOrderDetail = (currentOrder, orderDetails)->
  orderOptionDefault = calculateDefaultOrder(currentOrder, orderDetails)
  updateOrder = calculateOrderDeposit(currentOrder, orderOptionDefault)

  if currentOrder.paymentMethod is 0
    updateOrder.currentDeposit = updateOrder.finalPrice
    updateOrder.deposit = updateOrder.finalPrice
    updateOrder.debit = 0
  else if currentOrder.paymentMethod is 1
    updateOrder.deposit = 0
    updateOrder.debit = updateOrder.finalPrice

  console.log updateOrder
  Schema.orders.update currentOrder._id, $set: updateOrder

  currentOrder.saleCount       = updateOrder.saleCount
  currentOrder.discountCash    = updateOrder.discountCash
  currentOrder.discountPercent = updateOrder.discountPercent
  currentOrder.totalPrice      = updateOrder.totalPrice
  currentOrder.finalPrice      = updateOrder.finalPrice
  currentOrder.deposit         = updateOrder.deposit
  currentOrder.debit           = updateOrder.debit
#  currentOrder.paymentMethod   = updateOrder.paymentMethod   if updateOrder.paymentMethod
#  currentOrder.currentDeposit  = updateOrder.currentDeposit  if updateOrder.currentDeposit

  Session.set('currentOrder', currentOrder)

updateOrderByOrderDetailEmpty = (currentOrder)->
  updateOrder =
    saleCount       : 0
    discountCash    : 0
    discountPercent : 0
    totalPrice      : 0
    finalPrice      : 0
    paymentMethod   : 1
    currentDeposit  : 0
    deposit         : 0
    debit           : 0
  Schema.orders.update currentOrder._id, $set: updateOrder

Apps.Merchant.salesInit.push ->
  logics.sales.reCalculateOrder = (orderId) ->
    currentOrder = Schema.orders.findOne(orderId)
    if currentOrder
      orderDetails = Schema.orderDetails.find({order: orderId}).fetch()
      if orderDetails.length > 0
        updateOrderByOrderDetail(currentOrder, orderDetails)
      else
        updateOrderByOrderDetailEmpty(currentOrder)