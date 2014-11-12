logics.transactionManager = {newTransaction:{}}
Apps.Merchant.transactionManagerInit = []
Apps.Merchant.transactionManagerReactiveRun = []

Apps.Merchant.transactionManagerInit.push (scope) ->
  Session.setDefault('receivable', '0')
  Session.setDefault('transactionFilter', '1')
  Session.setDefault('createNewTransaction', {customerId: 'skyReset', description: '', totalCash: 0, depositCash: 0, maxCash: 0})
  logics.transactionManager.availableCustomers = []


Apps.Merchant.transactionManagerReactiveRun.push (scope) ->
  if Session.get('myProfile') && Session.get('receivable') && Session.get('transactionFilter')
    merchant = {merchant: Session.get('myProfile').currentMerchant}
    receivableFilter = if Session.get('receivable') is '0' then {receivable: true} else {receivable: false}
    transactionFilter =
      switch Session.get('transactionFilter')
        when '1' then {debitCash: {$gt: 0}}
        when '2' then {debitCash: {$gt: 0}}
        when '3' then {debitCash: 0}

    transaction = Schema.transactions.find({$and:[merchant,receivableFilter,transactionFilter]})
    logics.transactionManager.transactionDetailFilter = transaction

  Session.set('currentTransaction', Schema.transactions.findOne(Session.get('currentTransaction')?._id))

  if Session.get('currentTransaction')
    scope.transactionDetails = Schema.transactionDetails.find({transaction: Session.get('currentTransaction')._id})

  if Session.get('unSecureMode')
    Session.set('currentSelectCustomer')
  else
