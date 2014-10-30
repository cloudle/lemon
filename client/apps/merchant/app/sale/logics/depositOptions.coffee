calculateDepositAndDebit = (deposit, currentOrder)->
  if deposit >= currentOrder.finalPrice
    option=
      currentDeposit  : deposit
      paymentMethod   : 0
      deposit         : currentOrder.finalPrice
      debit           : 0
  else
    option=
      currentDeposit  : deposit
      paymentMethod   : 1
      deposit         : deposit
      debit           : currentOrder.finalPrice - deposit
  Order.update(currentOrder._id, {$set: option})

Apps.Merchant.salesInit.push ->
  logics.sales.depositOptions =
    reactiveSetter: (val) -> calculateDepositAndDebit(val, logics.sales.currentOrder)
    reactiveValue: -> Session.get('currentOrder').currentDeposit ? 0
    reactiveMax: -> 99999999999
    reactiveMin: -> 0
    reactiveStep: -> 1000
    others:
      forcestepdivisibility: 'none'

