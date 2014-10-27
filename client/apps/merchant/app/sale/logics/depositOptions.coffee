logics.sales.depositOptions = ->
  reactiveSetter: (val) ->
    if val >= logics.sales.currentOrder.finalPrice
      option=
        currentDeposit  : val
        paymentMethod   : 0
        deposit         : logics.sales.currentOrder.finalPrice
        debit           : 0

      Schema.orders.update(logics.sales.currentOrder._id, {$set: option}) if logics.sales.currentOrder
    else
      option=
        currentDeposit  : val
        paymentMethod   : 1
        deposit         : val
        debit           : logics.sales.currentOrder.finalPrice - val
      Schema.orders.update(logics.sales.currentOrder._id, {$set: option}) if logics.sales.currentOrder
  reactiveValue: -> logics.sales.currentOrder?.currentDeposit ? 0
  reactiveMax: -> 99999999999
  reactiveMin: -> 0
  reactiveStep: -> 1000
  others:
    forcestepdivisibility: 'none'

