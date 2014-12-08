logics.sales = { name: 'sale-logics' }
Apps.Merchant.salesInit = []
Apps.Merchant.salesReload = []
Apps.Merchant.salesReactiveRun = []

Apps.Merchant.salesInit.push (scope) ->
  scope.currentAllProductsInWarehouse = Product.insideWarehouse(Session.get('myProfile').currentWarehouse)
  scope.currentAllCustomers           = Customer.insideMerchant(Session.get('myProfile').parentMerchant)
  scope.currentAllSkulls              = Skull.insideMerchant(Session.get('myProfile').parentMerchant)
  scope.currentBranchProviders        = Provider.insideBranch(Session.get('myProfile').currentMerchant)
  scope.currentAllProviders           = Provider.insideMerchant(Session.get('myProfile').parentMerchant)
  scope.currentOrderHistory           = Order.myHistory(Session.get('myProfile').user, Session.get('myProfile').currentWarehouse, Session.get('myProfile').currentMerchant)
  scope.currentBranchStaff            = Meteor.users.find({})

Apps.Merchant.salesReload.push (scope) ->
  console.log 'reruning...'


Apps.Merchant.salesReactiveRun.push (scope) ->
  Session.set('currentOrder', Schema.orders.findOne(Session.get('mySession').currentOrder)) if Session.get('mySession')

#  scope.currentOrder = Order.findBy(Session.get('mySession').currentOrder) if Session.get('mySession')
#  if scope.currentOrder then Session.set('currentOrder', scope.currentOrder)

  if currentOrder = Session.get('currentOrder')
#    Session.set('currentOrder', scope.currentOrder)
#    Meteor.subscribe('orderDetails', scope.currentOrder._id)
    scope.currentOrderDetails = OrderDetail.findBy(currentOrder._id)
    scope.currentProduct      = Schema.products.findOne(currentOrder.currentProduct)

    if currentOrder.paymentsDelivery is 1
      deliveryOption = {
        contactName     : currentOrder.contactName
        contactPhone    : currentOrder.contactPhone
        deliveryAddress : currentOrder.deliveryAddress
        deliveryDate    : currentOrder.deliveryDate
        comment         : currentOrder.comment
        }
      currentDebit = 0
    else
      deliveryOption = {
        contactName     : null
        contactPhone    : null
        deliveryAddress : null
        deliveryDate    : null
        comment         : null
      }
      currentDebit = currentOrder.currentDeposit - currentOrder.finalPrice
    scope.deliveryDetail = deliveryOption
    scope.currentDebit   = currentDebit
    scope.finalPriceProduct   = currentOrder.currentTotalPrice - currentOrder.currentDiscountCash


  if scope.templateInstance
    if Session.get('currentOrder')?.paymentsDelivery is 0
      scope.templateInstance.ui.extras.toggleExtra('delivery', false)
    else
      scope.templateInstance.ui.extras.toggleExtra('delivery', true)

  if currentOrder = Session.get('currentOrder')
    if logics.sales.currentOrderDetails?.count() > 0
      allowSuccess = true
      if Session.get('currentOrder').paymentsDelivery is 1
        if !currentOrder.contactName then allowSuccess = false
        if !currentOrder.contactPhone then allowSuccess = false
        if !currentOrder.deliveryAddress then allowSuccess = false
        if !currentOrder.deliveryDate then allowSuccess = false
        if !currentOrder.comment then allowSuccess = false
      else
        if !Schema.customers.findOne(currentOrder.buyer) then allowSuccess = false

    else allowSuccess = false
    Session.set('allowSuccess', allowSuccess)

  if Session.get("salesEditingRowId")
    Session.set("salesEditingRow", Schema.orderDetails.findOne(Session.get("salesEditingRowId")))