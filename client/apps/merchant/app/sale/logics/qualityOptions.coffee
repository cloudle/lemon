logics.sales.qualityOptions = ->
  reactiveSetter: (val) ->
#    option = {}
#    option.currentQuality = val
#    if val > 0 && logics.sales.currentOrder.currentPrice > 0
#      option.currentDiscountPercent = Math.round(logics.sales.currentOrder.currentDiscountCash/(val * logics.sales.currentOrder.currentPrice)*100)
#    else
#      option.currentDiscountCash    = 0
#      option.currentDiscountPercent = 0
#
#    Schema.orders.update(logics.sales.currentOrder._id, {$set: option}) if logics.sales.currentOrder
#  reactiveValue: -> logics.sales.currentOrder?.currentQuality ? 0
#  reactiveMax: -> Session.get('currentProductMaxQuality') ? 1
  reactiveValue: -> 1
  reactiveMax: -> 10
  reactiveMin: -> 0
  reactiveStep: -> 1


