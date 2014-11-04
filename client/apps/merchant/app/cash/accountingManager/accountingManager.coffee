lemon.defineApp Template.accountingManager,
  rendered: ->
    $("[name=fromDate]").datepicker('setDate', Session.get('accountingFilterStartDate'))
    $("[name=toDate]").datepicker('setDate', Session.get('accountingFilterToDate'))

  events:
    "click #filterBills": (event, template)->
      Session.set('accountingFilterStartDate', $("[name=fromDate]").datepicker().data().datepicker.dates[0])
      Session.set('accountingFilterToDate', $("[name=toDate]").datepicker().data().datepicker.dates[0])

