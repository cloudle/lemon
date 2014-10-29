calculateBillDiscountPercent = (discountCash, currentOrder)->
  if currentOrder.billDiscount
    option = {discountCash: discountCash}
    if val > 0
      if val == currentOrder.totalPrice
        option.discountPercent = 100
      else
        option.discountPercent = val*100/currentOrder.totalPrice
    else
      option.discountPercent = 0
    option.finalPrice = currentOrder.totalPrice - option.discountCash
  Order.update(currentOrder._id, {$set: option})


logics.sales.billCashDiscountOptions =
  reactiveSetter: (val)-> calculateBillDiscountPercent(val, logics.sales.currentOrder)
  reactiveValue: -> logics.sales.currentOrder?.discountCash ? 0
  reactiveMax: -> logics.sales.currentOrder?.totalPrice ? 10000
  reactiveMin: -> 0
  reactiveStep: -> 1000
  others:
    forcestepdivisibility: 'none'

