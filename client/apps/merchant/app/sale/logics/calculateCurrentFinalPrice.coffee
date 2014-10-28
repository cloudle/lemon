logics.sales.finalPrice = ->
  totalPrice = logics.sales.currentOrder?.currentPrice * logics.sales.currentOrder?.currentQuality
  totalPrice - logics.sales.currentOrder?.currentDiscountCash


logics.sales.deliveryDetail = ->
  if logics.sales.currentOrder?.paymentsDelivery is 1
    {
    contactName     : logics.sales.currentOrder.contactName
    contactPhone    : logics.sales.currentOrder.contactPhone
    deliveryAddress : logics.sales.currentOrder.deliveryAddress
    deliveryDate    : logics.sales.currentOrder.deliveryDate
    comment         : logics.sales.currentOrder.comment
    }
  else {}

logics.sales.currentDebit = ->
  switch logics.sales.currentOrder?.paymentMethod
    when 0 then logics.sales.currentOrder.currentDeposit - logics.sales.currentOrder.finalPrice
    when 1 then 0