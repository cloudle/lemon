calculateCurrentDiscountCash = (val)->
  option = {}
  option.currentDiscountPercent = val
  total = logics.sales.currentOrder.currentQuality * logics.sales.currentOrder.currentPrice
  if val > 0
    option.currentDiscountCash = Math.round(total/100*val)
  else
    option.currentDiscountCash = 0

  Schema.orders.update(logics.sales.currentOrder._id, {$set: option}) if logics.sales.currentOrder


Apps.Merchant.salesInit.push ->
  logics.sales.discountPercentOptions =
    reactiveSetter: (val) -> calculateCurrentDiscountCash(val)
    reactiveValue: -> logics.sales.currentOrder?.currentDiscountPercent ? 0
    reactiveMax: -> 100
    reactiveMin: -> 0
    reactiveStep: -> 1


