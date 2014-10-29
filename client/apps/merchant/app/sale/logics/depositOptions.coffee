calculateDepositAndDebit = (deposit, currentOrder)->
  if val >= currentOrder.finalPrice
    option=
      currentDeposit  : val
      paymentMethod   : 0
      deposit         : currentOrder.finalPrice
      debit           : 0
  else
    option=
      currentDeposit  : val
      paymentMethod   : 1
      deposit         : val
      debit           : currentOrder.finalPrice - val
  Order.update(currentOrder._id, {$set: option})


logics.sales.depositOptions =
  reactiveSetter: (val) -> calculateDepositAndDebit(val, logics.sales.currentOrder)
  reactiveValue: -> logics.sales.currentOrder?.currentDeposit ? 0
  reactiveMax: -> 99999999999
  reactiveMin: -> 0
  reactiveStep: -> 1000
  others:
    forcestepdivisibility: 'none'

