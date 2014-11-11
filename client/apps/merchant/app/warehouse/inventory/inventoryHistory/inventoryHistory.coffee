lemon.defineApp Template.inventoryHistory,
  rendered: ->
    $("[name=fromDate]").datepicker('setDate', Session.get('inventoryHistoryFilterStartDate'))
    $("[name=toDate]").datepicker('setDate', Session.get('inventoryHistoryFilterToDate'))

  events:
    "click #filterInventoryHistories": (event, template)->
      Session.set('inventoryHistoryFilterStartDate', $("[name=fromDate]").datepicker().data().datepicker.dates[0])
      Session.set('inventoryHistoryFilterToDate', $("[name=toDate]").datepicker().data().datepicker.dates[0])

    "click .thumbnails": (event, template) ->
      Apps.MerchantSubscriber.subscribe('productLostInInventory', @_id)
      Apps.MerchantSubscriber.subscribe('inventoryDetailInWarehouse', @_id)
      Session.set('currentInventoryHistory', @)
      $(template.find '#inventoryHistoryDetail').modal()



