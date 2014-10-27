logics.sales.discountPercentOptions = ->
  reactiveSetter: (val) ->
    option = {}
    option.currentDiscountPercent = val
    if val > 0
      option.currentDiscountCash = Math.round((logics.sales.currentOrder.currentQuality * logics.sales.currentOrder.currentPrice)/100*val)
    else
      option.currentDiscountCash = 0

    Schema.orders.update(logics.sales.currentOrder._id, {$set: option}) if logics.sales.currentOrder
  reactiveValue: -> logics.sales.currentOrder?.currentDiscountPercent ? 0
  reactiveMax: -> 100
  reactiveMin: -> 0
  reactiveStep: -> 1


