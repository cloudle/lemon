calculateCurrentDiscountCash = (val)->
  if currentOrder = Session.get('currentOrder')
    totalPrice = currentOrder.currentQuality * currentOrder.currentPrice
    option = {currentDiscountPercent : val}
    if val > 0 then option.currentDiscountCash = Math.round(totalPrice/100*val)
    else option.currentDiscountCash = 0
    Schema.orders.update(currentOrder._id, {$set: option})

    currentOrder.currentDiscountCash    = option.currentDiscountCash
    currentOrder.currentDiscountPercent = option.currentDiscountPercent
    Session.set('currentOrder', currentOrder)


Apps.Merchant.salesInit.push ->
  logics.sales.discountPercentOptions =
    reactiveSetter: (val) -> calculateCurrentDiscountCash(val)
    reactiveValue: -> Session.get('currentOrder')?.currentDiscountPercent ? 0
    reactiveMax: -> 100
    reactiveMin: -> 0
    reactiveStep: -> 1


