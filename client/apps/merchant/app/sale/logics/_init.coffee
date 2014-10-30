logics.sales = { name: 'sale-logics' }
Apps.Merchant.salesInit = []
Apps.Merchant.salesReload = []

Apps.Merchant.salesInit.push (scope) ->
  logics.sales.currentAllProductsInWarehouse = Product.insideWarehouse(Session.get('myProfile').currentWarehouse)
  logics.sales.currentAllCustomers           = Customer.insideMerchant(Session.get('myProfile').parentMerchant)
  logics.sales.currentAllSkulls              = Skull.insideMerchant(Session.get('myProfile').parentMerchant)
  logics.sales.currentBranchProviders        = Provider.insideBranch(Session.get('myProfile').currentMerchant)
  logics.sales.currentAllProviders           = Provider.insideMerchant(Session.get('myProfile').parentMerchant)
  logics.sales.currentOrderHistory           = Order.myHistory(Session.get('myProfile').user, Session.get('myProfile').currentWarehouse, Session.get('myProfile').currentMerchant)


Apps.Merchant.salesReload.push (scope) ->
  console.log 'reruning...'


logics.sales.reactiveRun = ->
  logics.sales.currentOrder = Order.findBy(Session.get('mySession').currentOrder) if Session.get('mySession')
  if logics.sales.currentOrder
    Session.set('currentOrder', logics.sales.currentOrder)
    Apps.MerchantSubscriber.subscribe('orderDetails', logics.sales.currentOrder._id)
    logics.sales.currentOrderDetails = OrderDetail.findBy(logics.sales.currentOrder._id)
    logics.sales.currentProduct      = Schema.products.findOne(logics.sales.currentOrder.currentProduct)


    if logics.sales.currentOrder.paymentsDelivery is 1
      deliveryOption = {
        contactName     : logics.sales.currentOrder.contactName
        contactPhone    : logics.sales.currentOrder.contactPhone
        deliveryAddress : logics.sales.currentOrder.deliveryAddress
        deliveryDate    : logics.sales.currentOrder.deliveryDate
        comment         : logics.sales.currentOrder.comment
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
      currentDebit = logics.sales.currentOrder.currentDeposit - logics.sales.currentOrder.finalPrice
    logics.sales.deliveryDetail = deliveryOption
    logics.sales.currentDebit   = currentDebit
    logics.sales.finalPriceProduct   = logics.sales.currentOrder.currentTotalPrice - logics.sales.currentOrder.currentDiscountCash

  if logics.sales.templateInstance
    if logics.sales.currentOrder?.paymentsDelivery is 0
      logics.sales.templateInstance.ui.extras.toggleExtra('delivery', false)
    else
      logics.sales.templateInstance.ui.extras.toggleExtra('delivery', true)
