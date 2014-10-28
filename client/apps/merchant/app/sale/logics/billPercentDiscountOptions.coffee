logics.sales.billPercentDiscountOptions =
  reactiveSetter: (val)->
#    if logics.sales.currentOrder?.billDiscount
#      option = {}
#      option.discountPercent = val
#      if val > 0
#        if val == 100
#          option.discountCash = logics.sales.currentOrder.totalPrice
#        else
#          option.discountCash = Math.round(logics.sales.currentOrder.totalPrice*option.discountPercent/100)
#      else
#        option.discountCash = 0
#      option.finalPrice = logics.sales.currentOrder.totalPrice - option.discountCash
#    Schema.orders.update(logics.sales.currentOrder._id, {$set: option}) if logics.sales.currentOrder
  reactiveValue: -> Math.round(logics.sales.currentOrder?.discountPercent*100)/100 ? 0
  reactiveMax: -> 100
  reactiveMin: -> 0
  reactiveStep: -> 1
  others:
    forcestepdivisibility: 'none'
    decimals: 2

