logics.transactionManager = {}
Apps.Merchant.transactionManagerInit = []

Apps.Merchant.transactionManagerInit.push (scope) ->
  Session.setDefault('receivable', '0')
  Session.setDefault('transactionFilter', '1')
  logics.transactionManager.availableCustomers = []


logics.transactionManager.reactiveRun = ->
  if Session.get('myProfile') && Session.get('receivable') && Session.get('transactionFilter')
    merchant = {merchant: Session.get('myProfile').currentMerchant}
    receivableFilter = if Session.get('receivable') is '0' then {receivable: true} else {receivable: false}
    transactionFilter =
      switch Session.get('transactionFilter')
        when '1' then {debitCash: {$gt: 0}}
        when '2' then {debitCash: 0}
        when '3' then {debitCash: 0}

    transaction = Schema.transactions.find({$and:[merchant,receivableFilter,transactionFilter]})
    logics.transactionManager.transactionDetailFilter = transaction
