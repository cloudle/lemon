setTime = -> Session.set('realtime-now', new Date())

lemon.defineHyper Template.saleDetailSection,
  merchant: -> Schema.merchants.findOne(Session.get('myProfile')?.currentMerchant)
  editingMode: -> Session.get("salesEditingRow")?._id is @_id
  editingData: -> Session.get("salesEditingRow")
  deliveryMode: -> if Session.get("currentOrder").paymentsDelivery is 1 then true else false
  product: -> Schema.products.findOne(@product)
  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: -> Meteor.clearInterval(@timeInterval)

  events:
    "click .detail-row": ->
      Session.set("salesEditingRowId", @_id)
      Session.set("salesEditingRowShowUpdateCommand")

    "click .deleteOrderDetail": (event, template) ->
      Schema.orderDetails.remove @_id
      logics.sales.reCalculateOrder(@order)
