calculateCurrentDiscountPercent = (discountCash, currentOrder)->
  option = {currentDiscountCash: discountCash}
  total = currentOrder.currentQuality * currentOrder.currentPrice
  if discountCash > 0
    option.currentDiscountPercent = Math.round(discountCash/total*100)
  else
    option.currentDiscountPercent = 0

  Order.update(currentOrder._id, {$set: option})

Apps.Merchant.salesInit.push ->
  logics.sales.discountCashOptions =
    reactiveSetter: (val)-> calculateCurrentDiscountPercent(val, Session.get('currentOrder'))
    reactiveValue: -> Session.get('currentOrder').currentDiscountCash ? 0
    reactiveMax: ->  Session.get('currentOrder').currentTotalPrice ? 0
    reactiveMin: -> 0
    reactiveStep: -> 1000
    others:
      forcestepdivisibility: 'none'


