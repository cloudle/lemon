setTime = -> Session.set('realtime-now', new Date())

lemon.defineHyper Template.saleDetailSection,
  merchant: -> Schema.merchants.findOne(Session.get('myProfile')?.currentMerchant)
  editingMode: -> Session.get("salesEditingRow")?._id is @_id
  editingData: -> Session.get("salesEditingRow")
  product: -> Schema.products.findOne(@product)
  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: -> Meteor.clearInterval(@timeInterval)
  buyerName: -> Schema.customers.findOne(Session.get("currentOrder")?.buyer)?.name
  sellerName: -> Schema.userProfiles.findOne({user: Session.get("currentOrder")?.seller})?.fullName
  customerDebt: ->
    customer = Schema.customers.findOne(Session.get("currentOrder")?.buyer)
    if customer then customer.saleDebt + customer.customSaleDebt else 0

  customerFinalDebt: ->
    customer = Schema.customers.findOne(Session.get("currentOrder")?.buyer)
    if customer and @order
      customer.saleDebt + customer.customSaleDebt + @order.finalPrice - @order.currentDeposit
    else 0
  events:
    "click .detail-row": ->
      Session.set("salesEditingRowId", @_id)
      Session.set("salesEditingRowShowUpdateCommand")

    "click .deleteOrderDetail": (event, template) ->
      Schema.orderDetails.remove @_id
      logics.sales.reCalculateOrder(@order)
