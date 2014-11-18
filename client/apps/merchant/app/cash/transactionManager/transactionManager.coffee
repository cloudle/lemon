lemon.defineApp Template.transactionManager,
  unSecureMode: -> true
  allowCreate: ->
    newTransaction = Session.get('createNewTransaction')
    if newTransaction.customerId != 'skyReset' and newTransaction.totalCash > 0 and newTransaction.totalCash >= newTransaction.depositCash and newTransaction.description.length > 0
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

    'click .excel-transaction': (event, template) -> $(".excelFileSource").click()
    'change .excelFileSource': (event, template) ->
      if event.target.files.length > 0
        console.log 'importing'
        $excelSource = $(".excelFileSource")
        $excelSource.parse
          config:
            complete: (results, file) ->
              console.log file
              console.log results
              #              if file.name is "nhap_kho.csv"
              #              if file.type is "text/csv" || file.type is "application/vnd.ms-excel"
              logics.transactionManager.importFileTransactionCSV(results.data)

        $excelSource.val("")



