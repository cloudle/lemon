logics.sales.priceOptions = ->
  reactiveSetter: (val)->
    Schema.orders.update(logics.sales.currentOrder._id, {$set: {currentPrice: val}}) if logics.sales.currentOrder
  reactiveValue: -> logics.sales.currentOrder?.currentPrice ? 0
  reactiveMax: -> 999999999
  reactiveMin: -> Session.get('currentProductInstance')?.price ? 0
  reactiveStep: -> 1000


