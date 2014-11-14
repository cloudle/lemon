lemon.defineApp Template.transactionManager,
  unSecureMode: -> true
  allowCreate: ->
    newTransaction = Session.get('createNewTransaction')
    if newTransaction.customerId != 'skyReset' and newTransaction.totalCash > 0 and newTransaction.totalCash > newTransaction.depositCash and newTransaction.description.length > 0
      ''
    else 'disabled'

  activeReceivable: (receivable)-> return 'active' if Session.get('receivable') is receivable
  activeTransactionFilter: (filter)-> return 'active' if Session.get('transactionFilter') is filter

  rendered: -> $("[name=debtDate]").datepicker('setDate', Session.get('createNewTransaction').debtDate)
  events:
    "click [data-receivable]": (event, template) ->
      $element = $(event.currentTarget)
      Session.set 'receivable', $element.attr("data-receivable")

    "click [data-filter]": (event, template) ->
      $element = $(event.currentTarget)
      Session.set 'transactionFilter', $element.attr("data-filter")

    "input .description": (event, template) -> logics.transactionManager.updateDescription(template.find(".description"))
    "change [name ='debtDate']": (event, template) -> logics.transactionManager.updateDebtDate()
    "click .createTransaction":  (event, template) -> logics.transactionManager.createTransaction()
    "click .thumbnails": (event, template) ->
      Meteor.subscribe('transactionDetails', @_id)
      Session.set('currentTransaction', @)
      Session.set('showAddTransactionDetail', false)
      $(template.find '#transactionManagerDetail').modal()



