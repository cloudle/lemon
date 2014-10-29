logics.sales.priceOptions =
  reactiveSetter: (val)-> Order.update(logics.sales.currentOrder._id, {$set: {currentPrice: val}})
  reactiveValue: -> logics.sales.currentOrder?.currentPrice ? 0
  reactiveMax: -> 999999999
  reactiveMin: -> logics.sales.currentProduct?.price ? 0
  reactiveStep: -> 1000


