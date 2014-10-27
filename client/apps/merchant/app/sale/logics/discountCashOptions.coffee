logics.sales.discountCashOptions = ->
  reactiveSetter: (val)->
    option = {}
    option.currentDiscountCash = val
    if val > 0
      option.currentDiscountPercent = Math.round(val/(logics.sales.currentOrder.currentQuality * logics.sales.currentOrder.currentPrice)*100)
    else
      option.currentDiscountPercent = 0

    Schema.orders.update(logics.sales.currentOrder._id, {$set: option}) if logics.sales.currentOrder
  reactiveValue: -> logics.sales.currentOrder?.currentDiscountCash ? 0
  reactiveMax: ->  Session.get('currentProductMaxTotalPrice') ? 0
  reactiveMin: -> 0
  reactiveStep: -> 1000
  others:
    forcestepdivisibility: 'none'


