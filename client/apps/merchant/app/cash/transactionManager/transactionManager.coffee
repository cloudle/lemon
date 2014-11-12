lemon.defineApp Template.transactionManager,
  unSecureMode: -> true
  allowCreate: ->
    newTransaction = Session.get('createNewTransaction')
    if newTransaction.customerId != 'skyReset' and newTransaction.totalCash > 0 and newTransaction.totalCash > newTransaction.depositCash and newTransaction.description.length > 0
      'btn-success'
    else'btn-default disabled'

  activeReceivable: (receivable)-> return 'active' if Session.get('receivable') is receivable
  activeTransactionFilter: (filter)-> return 'active' if Session.get('transactionFilter') is filter

  rendered: ->
    $("[name=debtDate]").datepicker('setDate', Session.get('createNewTransaction').debtDate)

  events:
    "click [data-receivable]": (event, template) ->
      $element = $(event.currentTarget)
      Session.set 'receivable', $element.attr("data-receivable")

    "click [data-filter]": (event, template) ->
      $element = $(event.currentTarget)
      Session.set 'transactionFilter', $element.attr("data-filter")

    "blur .description": (event, template) ->
      description = template.find(".description")
      if Session.get('createNewTransaction')?.customerId != 'skyReset'
        if description.value.length >= 0
          createNewTransaction = Session.get('createNewTransaction')
          createNewTransaction.description = description.value
          Session.set('createNewTransaction', createNewTransaction)
      else
        description.value = Session.get('createNewTransaction').description

    "change [name ='debtDate']": (event, template) ->
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


    "click .createTransaction": (event, template) ->
      if Session.get('createNewTransaction')?.customerId
        Transaction.newByUser(
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


    "click .thumbnails": (event, template) ->
      Meteor.subscribe('transactionDetails', @_id)
      Session.set('currentTransaction', @)
      Session.set('showAddTransactionDetail', false)
      $(template.find '#transactionManagerDetail').modal()



