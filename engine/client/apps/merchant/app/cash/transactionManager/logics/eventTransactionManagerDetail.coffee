Apps.Merchant.transactionManagerInit.push (scope) ->
  scope.updateDescription = (description)->
    if Session.get('createNewTransaction')?.customerId != 'skyReset'
      if description.value.length >= 0
        createNewTransaction = Session.get('createNewTransaction')
        createNewTransaction.description = description.value
        Session.set('createNewTransaction', createNewTransaction)
    else
      description.value = Session.get('createNewTransaction').description

  scope.updateDebtDate = ()->
    date = $("[name=debtDate]").datepicker().data().datepicker.dates[0]
    toDate = new Date
    if date and Session.get('createNewTransaction')?.customerId == 'skyReset'
      createNewTransaction = Session.get('createNewTransaction')
      createNewTransaction.debtDate = undefined
      Session.set('createNewTransaction', createNewTransaction)
      $("[name=debtDate]").datepicker('setDate', undefined)

    if date and Session.get('createNewTransaction')?.customerId != 'skyReset'
      deliveryToDate = new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate())
      debtDate = new Date(date.getFullYear(), date.getMonth(), date.getDate())
      if debtDate > deliveryToDate
        debtDate = deliveryToDate; $("[name=debtDate]").datepicker('setDate', debtDate)

      createNewTransaction = Session.get('createNewTransaction')
      createNewTransaction.debtDate = debtDate
      Session.set('createNewTransaction', createNewTransaction)


  scope.showTransactionDetail = () ->
    Session.set('showAddTransactionDetail', true)
#    $("[name=createDebtDate]").datepicker('setDate', Session.get('transactionDetailPaymentDate'))
    $("[name=createDebtDate]").datepicker('setDate', new Date())

  scope.createNewTransactionDetail = () ->
    Meteor.call 'addTransactionDetail',
      Session.get('currentTransaction')._id,
      Session.get('depositCashNewTransactionDetail'),
      Session.get('transactionDetailPaymentDate'),
      (error, result) ->
        if error then console.log error
        else
          Session.set('depositCashNewTransactionDetail', 0)
          Session.set('transactionDetailPaymentDate', new Date())
          $("[name=createDebtDate]").datepicker('setDate', Session.get('transactionDetailPaymentDate'))


