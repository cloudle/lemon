calculateBillDiscountCash = (discountPercent, currentOrder)->
  if currentOrder.billDiscount
    option = {discountPercent : discountPercent}
    if discountPercent > 0
      if discountPercent == 100
        option.discountCash = currentOrder.totalPrice
      else
        option.discountCash = Math.round(currentOrder.totalPrice*option.discountPercent/100)
    else
      option.discountCash = 0
    option.finalPrice = currentOrder.totalPrice - option.discountCash
  Schema.orders.update(currentOrder._id, {$set: option})

reactiveMaxPercentDiscount = ->
  if Session.get('currentOrder')?.billDiscount then 100
  else Session.get('currentOrder')?.discountPercent ? 0

reactiveMinBillPercentDiscount = ->
  if Session.get('currentOrder')?.billDiscount then 0
  else Session.get('currentOrder')?.discountPercent ? 0

Apps.Merchant.salesInit.push ->
  logics.sales.billPercentDiscountOptions =
    reactiveSetter: (val)-> calculateBillDiscountCash(val, Session.get('currentOrder'))
    reactiveValue: -> Math.round(Session.get('currentOrder')?.discountPercent*100)/100 ? 0
    reactiveMax: -> reactiveMaxPercentDiscount()
    reactiveMin: -> reactiveMinBillPercentDiscount()
    reactiveStep: -> 1
    others:
      forcestepdivisibility: 'none'
      decimals: 2