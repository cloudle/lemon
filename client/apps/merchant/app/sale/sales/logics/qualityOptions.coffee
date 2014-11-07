calculateDiscountCashAndDiscountPercent  = (quality, currentOrder)->
  if logics.sales.currentProduct and currentOrder
    option = {currentQuality : quality}
    if quality > 0 && currentOrder.currentPrice > 0
      option.currentDiscountPercent = Math.round(currentOrder.currentDiscountCash/(quality * currentOrder.currentPrice)*100)
    else
      option.currentDiscountCash    = 0
      option.currentDiscountPercent = 0
    option.currentTotalPrice = quality * currentOrder.currentPrice
    Order.update(currentOrder._id, {$set: option})

Apps.Merchant.salesReactiveRun.push (scope) ->
  return if !scope.validation.getCrossProductQuality
#  if logics.sales.currentProduct
#    qualityProduct = logics.sales.currentProduct?.availableQuality
#    orderDetail = _.where(logics.sales.currentOrderDetails.fetch(), {product: logics.sales.currentOrder.currentProduct})
#    for detail in orderDetail
#      qualityProduct -= detail.quality
#    qualityProduct
#  else 0

  if logics.sales.currentProduct and logics.sales.currentOrder
    cross = logics.sales.validation.getCrossProductQuality(logics.sales.currentProduct._id, logics.sales.currentOrder._id)
    Session.set 'saleAppMaxQuality', (cross.product.availableQuality - cross.quality)
  else Session.set 'saleAppMaxQuality', 0

Apps.Merchant.salesInit.push (scope) ->
  logics.sales.qualityOptions =
    reactiveSetter: (val) -> calculateDiscountCashAndDiscountPercent(val, logics.sales.currentOrder)
    reactiveValue: -> logics.sales.currentOrder?.currentQuality ? 0
    reactiveMax: -> Session.get('saleAppMaxQuality') ? 0
    reactiveMin: -> 0
    reactiveStep: -> 1


