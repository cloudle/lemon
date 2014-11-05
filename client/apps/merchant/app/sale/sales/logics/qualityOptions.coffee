calculateDiscountCashAndDiscountPercent  = (quality, currentOrder)->
  option = {currentQuality : quality}
  if quality > 0 && currentOrder.currentPrice > 0
    option.currentDiscountPercent = Math.round(currentOrder.currentDiscountCash/(quality * currentOrder.currentPrice)*100)
  else
    option.currentDiscountCash    = 0
    option.currentDiscountPercent = 0
  option.currentTotalPrice = quality * currentOrder.currentPrice
  Order.update(currentOrder._id, {$set: option})

reactiveMaxQuality = ->
  if logics.sales.currentProduct
    qualityProduct = logics.sales.currentProduct?.availableQuality
    qualityOrderDetail = _.findWhere(logics.sales.currentOrderDetails?.fetch(), {product: logics.sales.currentOrder?.currentProduct})?.quality ? 0
    max = qualityProduct - qualityOrderDetail
  else 0

Apps.Merchant.salesInit.push ->
  logics.sales.qualityOptions =
    reactiveSetter: (val) -> calculateDiscountCashAndDiscountPercent(val, logics.sales.currentOrder)
    reactiveValue: -> logics.sales.currentOrder?.currentQuality ? 0
    reactiveMax: -> reactiveMaxQuality()
    reactiveMin: -> 0
    reactiveStep: -> 1

