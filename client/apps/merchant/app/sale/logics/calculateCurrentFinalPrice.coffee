logics.sales.finalPrice = ->
  totalPrice = logics.sales.currentOrder?.currentPrice * logics.sales.currentOrder?.currentQuality
  totalPrice - logics.sales.currentOrder?.currentDiscountCash