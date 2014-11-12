lemon.defineApp Template.transportHistory,
  rendered: ->
    $("[name=fromDate]").datepicker('setDate', Session.get('transportHistoryFilterStartDate'))
    $("[name=toDate]").datepicker('setDate', Session.get('transportHistoryFilterToDate'))

  events:
    "click .createTransport": (event, template) -> Router.go('/transport')
    "click #filterTransportHistories": (event, template)->
      Session.set('transportHistoryFilterStartDate', $("[name=fromDate]").datepicker().data().datepicker.dates[0])
      Session.set('transportHistoryFilterToDate', $("[name=toDate]").datepicker().data().datepicker.dates[0])

    "click .thumbnails": (event, template) ->
      Meteor.subscribe('productLostInTransport', @_id)
      Meteor.subscribe('transportDetailInWarehouse', @_id)
      Session.set('currentTransportHistory', @)
      $(template.find '#transportHistoryDetail').modal()



