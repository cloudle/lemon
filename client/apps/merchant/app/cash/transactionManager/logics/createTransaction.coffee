Apps.Merchant.transactionManagerInit.push (scope) ->
  scope.createTransaction = ()->
    if Session.get('createNewTransaction')?.customerId
      Transaction.newByCustomer(
        Session.get('createNewTransaction').customerId,
        Session.get('createNewTransaction').description,
        Session.get('createNewTransaction').totalCash,
        Session.get('createNewTransaction').depositCash,
        Session.get('createNewTransaction').debtDate
      )

      createNewTransaction = Session.get('createNewTransaction')
      createNewTransaction.customerId = 'skyReset'
      createNewTransaction.description = ''
      createNewTransaction.maxCash = 0
      createNewTransaction.debtDate = new Date()
      Session.set('createNewTransaction', createNewTransaction)

