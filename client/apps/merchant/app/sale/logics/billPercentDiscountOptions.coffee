calculateBillDiscountCash = (discountPercent, currentOrder)->
  if logics.sales.currentOrder?.billDiscount
    option = {discountPercent : discountPercent}
    if val > 0
      if val == 100
        option.discountCash = currentOrder.totalPrice
      else
        option.discountCash = Math.round(currentOrder.totalPrice*option.discountPercent/100)
    else
      option.discountCash = 0
    option.finalPrice = currentOrder.totalPrice - option.discountCash
  Order.update(logics.sales.currentOrder._id, {$set: option})

logics.sales.billPercentDiscountOptions =
  reactiveSetter: (val)-> calculateBillDiscountCash(val, logics.sales.currentOrder)
  reactiveValue: -> Math.round(logics.sales.currentOrder?.discountPercent*100)/100 ? 0
  reactiveMax: -> 100
  reactiveMin: -> 0
  reactiveStep: -> 1
  others:
    forcestepdivisibility: 'none'
    decimals: 2