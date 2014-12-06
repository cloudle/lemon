calculateDepositAndDebit = (deposit)->
  if currentOrder = Session.get('currentOrder')
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
    Schema.orders.update(currentOrder._id, {$set: option})

    currentOrder.currentDeposit = option.currentDeposit
    currentOrder.paymentMethod  = option.paymentMethod
    currentOrder.deposit        = option.deposit
    currentOrder.debit          = option.debit
    Session.set('currentOrder', currentOrder)

Apps.Merchant.salesInit.push ->
  logics.sales.depositOptions =
    reactiveSetter: (val) -> calculateDepositAndDebit(val)
    reactiveValue: -> Session.get('currentOrder')?.currentDeposit ? 0
    reactiveMax: -> 99999999999
    reactiveMin: -> 0
    reactiveStep: -> 1000
    others:
      forcestepdivisibility: 'none'

