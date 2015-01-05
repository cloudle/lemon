Apps.Merchant.transactionManagerInit.push (scope) ->
  scope.totalCashOptions =
    reactiveSetter: (val) ->
      createNewTransaction = Session.get('createNewTransaction')
      createNewTransaction.totalCash = val
      Session.set('createNewTransaction', createNewTransaction)

    reactiveValue : -> Session.get('createNewTransaction')?.totalCash ? 0
    reactiveMax   : -> Session.get('createNewTransaction')?.maxCash ? 0
    reactiveMin   : -> 0
    reactiveStep  : -> 10000

  scope.depositCashOptions =
    reactiveSetter: (val) ->
      createNewTransaction = Session.get('createNewTransaction')
      createNewTransaction.depositCash = val
      Session.set('createNewTransaction', createNewTransaction)

    reactiveValue : -> Session.get('createNewTransaction')?.depositCash ? 0
    reactiveMax   : -> Session.get('createNewTransaction')?.totalCash ? 0
    reactiveMin   : -> 0
    reactiveStep  : -> 10000


