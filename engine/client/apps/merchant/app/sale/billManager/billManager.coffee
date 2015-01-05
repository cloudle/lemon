lemon.defineApp Template.billManager,
  rendered: ->
    $("[name=fromDate]").datepicker('setDate', Session.get('billFilterStartDate'))
    $("[name=toDate]").datepicker('setDate', Session.get('billFilterToDate'))

  events:
    "click .createSale": (event, template)-> Router.go('/sales')
    "click #filterBills": (event, template)->
      Session.set('billFilterStartDate', $("[name=fromDate]").datepicker().data().datepicker.dates[0])
      Session.set('billFilterToDate', $("[name=toDate]").datepicker().data().datepicker.dates[0])
    "click .thumbnails": (event, template) ->
      Meteor.subscribe('saleDetails', @_id)
      Session.set('currentBillManagerSale', @)
      $(template.find '#salePreview').modal()