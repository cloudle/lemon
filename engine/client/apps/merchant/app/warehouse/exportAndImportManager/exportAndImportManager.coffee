lemon.defineApp Template.exportAndImportManager,
  rendered: ->
    $("[name=fromDate]").datepicker('setDate', Session.get('exportAndImportFilterStartDate'))
    $("[name=toDate]").datepicker('setDate', Session.get('exportAndImportFilterToDate'))

  events:
    "click #filterBills": (event, template)->
      Session.set('exportAndImportFilterStartDate', $("[name=fromDate]").datepicker().data().datepicker.dates[0])
      Session.set('exportAndImportFilterToDate', $("[name=toDate]").datepicker().data().datepicker.dates[0])
