calculateBillDiscountPercent = (discountCash, currentOrder)->
  if currentOrder.billDiscount
    option = {discountCash: discountCash}
    if discountCash > 0
      if discountCash == currentOrder.totalPrice
        option.discountPercent = 100
      else
        option.discountPercent = discountCash*100/currentOrder.totalPrice
    else
      option.discountPercent = 0
    option.finalPrice = currentOrder.totalPrice - option.discountCash
  Order.update(currentOrder._id, {$set: option})

reactiveMaxBillCashDiscount = ->
  if Session.get('currentOrder')?.billDiscount then Session.get('currentOrder')?.totalPrice ? 0
  else Session.get('currentOrder')?.discountCash ? 0

reactiveMinBillCashDiscount = ->
  if Session.get('currentOrder')?.billDiscount then 0
  else Session.get('currentOrder')?.discountCash ? 0

Apps.Merchant.salesInit.push ->
  logics.sales.billCashDiscountOptions =
    reactiveSetter: (val)-> calculateBillDiscountPercent(val, Session.get('currentOrder'))
    reactiveValue: -> Session.get('currentOrder')?.discountCash ? 0
    reactiveMax: -> reactiveMaxBillCashDiscount()
    reactiveMin: -> reactiveMinBillCashDiscount()
    reactiveStep: -> 1000
    others:
      forcestepdivisibility: 'none'

