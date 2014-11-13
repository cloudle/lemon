Apps.Merchant.transactionManagerInit.push (scope) ->
  scope.showTransactionDetail = () ->
    Session.set('showAddTransactionDetail', true)
    $("[name=createDebtDate]").datepicker('setDate', Session.get('transactionDetailPaymentDate'))

  scope.createNewTransactionDetail = () ->
    Meteor.call 'addTransactionDetail',
      Session.get('currentTransaction')._id,
      Session.get('depositCashNewTransactionDetail'),
      Session.get('transactionDetailPaymentDate'),
      (error, result) ->
        if error then console.log error.error
        else
          Session.set('depositCashNewTransactionDetail', 0)
          Session.set('transactionDetailPaymentDate', new Date())
          console.log Session.get('transactionDetailPaymentDate')
          $("[name=createDebtDate]").datepicker('setDate', Session.get('transactionDetailPaymentDate'))


