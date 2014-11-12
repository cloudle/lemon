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


Apps.Merchant.salesReload.push (scope) ->
  console.log 'reruning...'


Apps.Merchant.salesReactiveRun.push (scope) ->
  scope.currentOrder = Order.findBy(Session.get('mySession').currentOrder) if Session.get('mySession')
  if scope.currentOrder
    Session.set('currentOrder', scope.currentOrder)
    Meteor.subscribe('orderDetails', scope.currentOrder._id)
    scope.currentOrderDetails = OrderDetail.findBy(scope.currentOrder._id)
    scope.currentProduct      = Schema.products.findOne(scope.currentOrder.currentProduct)

    if scope.currentOrder.paymentsDelivery is 1
      deliveryOption = {
        contactName     : scope.currentOrder.contactName
        contactPhone    : scope.currentOrder.contactPhone
        deliveryAddress : scope.currentOrder.deliveryAddress
        deliveryDate    : scope.currentOrder.deliveryDate
        comment         : scope.currentOrder.comment
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
      currentDebit = scope.currentOrder.currentDeposit - scope.currentOrder.finalPrice
    scope.deliveryDetail = deliveryOption
    scope.currentDebit   = currentDebit
    scope.finalPriceProduct   = scope.currentOrder.currentTotalPrice - scope.currentOrder.currentDiscountCash


  if scope.templateInstance
    if scope.currentOrder?.paymentsDelivery is 0
      scope.templateInstance.ui.extras.toggleExtra('delivery', false)
    else
      scope.templateInstance.ui.extras.toggleExtra('delivery', true)

  if Session.get('currentOrder')
    if logics.sales.currentOrderDetails?.count() > 0
      allowSuccess = true
      if scope.currentOrder.paymentsDelivery is 1
        if !Session.get('currentOrder').contactName then allowSuccess = false
        if !Session.get('currentOrder').contactPhone then allowSuccess = false
        if !Session.get('currentOrder').deliveryAddress then allowSuccess = false
        if !Session.get('currentOrder').deliveryDate then allowSuccess = false
        if !Session.get('currentOrder').comment then allowSuccess = false
    else allowSuccess = false
    Session.set('allowSuccess', allowSuccess)






