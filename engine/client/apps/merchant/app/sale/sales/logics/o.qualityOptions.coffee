calculateDiscountCashAndDiscountPercent  = (quality, currentOrder)->
  if logics.sales.currentProduct and currentOrder
    option = {currentQuality : quality}
    if quality > 0 && currentOrder.currentPrice > 0
      option.currentDiscountPercent = Math.round(currentOrder.currentDiscountCash/(quality * currentOrder.currentPrice)*100)
    else
      option.currentDiscountCash    = 0
      option.currentDiscountPercent = 0
    option.currentTotalPrice = quality * currentOrder.currentPrice
    Schema.orders.update(currentOrder._id, {$set: option})

    currentOrder.currentQuality         = option.currentQuality
    currentOrder.currentDiscountCash    = option.currentDiscountCash if option.currentDiscountCash
    currentOrder.currentDiscountPercent = option.currentDiscountPercent
    currentOrder.currentTotalPrice      = option.currentTotalPrice
    Session.set('currentOrder', currentOrder)

Apps.Merchant.salesInit.push (scope) ->
  logics.sales.qualityOptions =
    reactiveSetter: (val) -> calculateDiscountCashAndDiscountPercent(val, Session.get('currentOrder'))
    reactiveValue: -> Session.get('currentOrder')?.currentQuality ? 0
    reactiveMax: -> Session.get('saleAppMaxQuality') ? 0
    reactiveMin: -> 0
    reactiveStep: -> 1


