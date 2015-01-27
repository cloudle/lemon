setTime = -> Session.set('realtime-now', new Date())

lemon.defineHyper Template.saleDetailSection,
  merchant: -> Schema.merchants.findOne(Session.get('myProfile')?.currentMerchant)
  editingMode: -> Session.get("salesEditingRow")?._id is @_id
  editingData: -> Session.get("salesEditingRow")
#  product: -> Schema.products.findOne(@product)
#  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
  buyerName: -> Schema.customers.findOne(Session.get("currentOrder")?.buyer)?.name
  buyer: -> Schema.customers.findOne(Session.get("currentOrder")?.buyer)
  sellerName: -> Schema.userProfiles.findOne({user: Session.get("currentOrder")?.seller})?.fullName
  billNo: -> Helpers.orderCodeCreate(Schema.customers.findOne(Session.get("currentOrder")?.buyer)?.billNo ? '0000')

  orderDescription: -> Session.get("currentOrderDescription") ? @order?.description
  customerOldDebt: ->
    customer = Schema.customers.findOne(Session.get("currentOrder")?.buyer)
    if customer then customer.saleDebt + customer.customSaleDebt else 0

  customerFinalDebt: ->
    customer = Schema.customers.findOne(Session.get("currentOrder")?.buyer)
    if customer and @order
      customer.saleDebt + customer.customSaleDebt + @order.finalPrice - @order.currentDeposit
    else 0

  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: ->
    Meteor.clearInterval(@timeInterval)
    Session.set("currentOrderDescription")


  events:
    "click .detail-row": ->
      Session.set("salesEditingRowId", @_id)
      Session.set("salesEditingRowShowUpdateCommand")

    "click .deleteOrderDetail": (event, template) ->
      Schema.orderDetails.remove @_id
      logics.sales.reCalculateOrder(@order)

    "input [name='orderDescription']": (event, template) ->
      Helpers.deferredAction ->
        description = template.ui.$orderDescription.val()
        Session.set("currentOrderDescription", description)
        Schema.orders.update Session.get("currentOrder")._id, $set:{description: description} if Session.get("currentOrder")
      , "currentSaleUpdateDescription", 1000


