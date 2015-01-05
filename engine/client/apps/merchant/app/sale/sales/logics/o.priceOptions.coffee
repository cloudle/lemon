Apps.Merchant.salesInit.push ->
  logics.sales.priceOptions =
    reactiveSetter: (val)->
      if currentOder = Session.get('currentOrder')
        currentOder.currentPrice = val
        Session.set('currentOrder', currentOder)
        Schema.orders.update currentOder._id, {$set: {currentPrice: val}}

    reactiveValue: -> Session.get('currentOrder')?.currentPrice ? 0
    reactiveMax: -> 999999999
    reactiveMin: -> logics.sales.currentProduct?.price ? 0
    reactiveStep: -> 1000
    others:
      forcestepdivisibility: 'none'


