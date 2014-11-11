lemon.defineApp Template.transactionManager,
  unSecureMode: -> true

  activeReceivable: (receivable)-> return 'active' if Session.get('receivable') is receivable
  activeTransactionFilter: (filter)-> return 'active' if Session.get('transactionFilter') is filter

  events:
    "click [data-receivable]": (event, template) ->
      $element = $(event.currentTarget)
      Session.set 'receivable', $element.attr("data-receivable")
    "click [data-filter]": (event, template) ->
      $element = $(event.currentTarget)
      Session.set 'transactionFilter', $element.attr("data-filter")

    "click .createTransaction": (event, template) ->
      transaction = Transaction.newByUser(
        logics.transactionManager.createTransactionCustomer,
        logics.transactionManager.createTransactionDebitCash,
        0)


    "click .thumbnails": (event, template) ->
      Apps.MerchantSubscriber.subscribe('transactionDetails', @_id)
      Session.set('currentTransaction', @)
      $(template.find '#transactionManagerDetail').modal()


