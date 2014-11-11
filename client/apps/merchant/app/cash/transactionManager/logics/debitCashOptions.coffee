Apps.Merchant.transactionManagerInit.push (scope) ->
  scope.debitCashOptions =
    reactiveSetter: (val) -> scope.createTransactionDebitCash = val
    reactiveValue: -> 0
    reactiveMax: -> 9000000000
    reactiveMin: -> 0
    reactiveStep: -> 10000


