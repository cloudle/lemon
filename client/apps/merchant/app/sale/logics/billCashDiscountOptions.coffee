logics.sales.billCashDiscountOptions = ->
  reactiveSetter: (val)->
    if logics.sales.currentOrder?.billDiscount
      option = {}
      option.discountCash = val
      if val > 0
        if val == logics.sales.currentOrder.totalPrice
          option.discountPercent = 100
        else
          option.discountPercent = val*100/logics.sales.currentOrder.totalPrice
      else
        option.discountPercent = 0
      option.finalPrice = logics.sales.currentOrder.totalPrice - option.discountCash
    Schema.orders.update(logics.sales.currentOrder._id, {$set: option}) if logics.sales.currentOrder
  reactiveValue: -> logics.sales.currentOrder?.discountCash ? 0
  reactiveMax: ->
    if logics.sales.currentOrder?.billDiscount
      logics.sales.currentOrder?.totalPrice ? 0
    else
      logics.sales.currentOrder?.discountCash ? 0
  reactiveMin: ->
    if logics.sales.currentOrder?.billDiscount
      0
    else
      logics.sales.currentOrder?.discountCash ? 0
  reactiveStep: -> 1000
  others:
    forcestepdivisibility: 'none'

