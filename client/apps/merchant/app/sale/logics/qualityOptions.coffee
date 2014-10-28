maxQuality = ->
  qualityProduct = logics.sales.currentProduct?.availableQuality
  qualityOrderDetail = _.findWhere(logics.sales.currentOrderDetails?.fetch(), {product: logics.sales.currentOrder?.currentProduct})?.quality ? 0
  max = qualityProduct - qualityOrderDetail
  max

calculateProductDiscount = (val)->
  option = {}
  option.currentQuality = val
  if val > 0 && logics.sales.currentOrder.currentPrice > 0
    option.currentDiscountPercent = Math.round(logics.sales.currentOrder.currentDiscountCash/(val * logics.sales.currentOrder.currentPrice)*100)
  else
    option.currentDiscountCash    = 0
    option.currentDiscountPercent = 0

  Schema.orders.update(logics.sales.currentOrder._id, {$set: option}) if logics.sales.currentOrder

logics.sales.maxQuality = 100
logics.sales.qualityOptions =
  reactiveSetter: (val) -> calculateProductDiscount(val)
  reactiveValue: -> logics.sales.currentOrder?.currentQuality ? 0
  reactiveMax: -> logics.sales.maxQuality ? 1
#  reactiveMax: -> maxQuality ? 1
  reactiveMin: -> 0
  reactiveStep: -> 1


