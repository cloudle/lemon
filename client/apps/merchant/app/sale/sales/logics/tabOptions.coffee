destroySaleAndDetail = (orderId)->
  order = Schema.orders.findOne({
    _id       : orderId
    creator   : Session.get('myProfile').user
    merchant  : Session.get('myProfile').currentMerchant
    warehouse : Session.get('myProfile').currentWarehouse})
  if order
    for orderDetail in Schema.orderDetails.find({order: order._id}).fetch()
      Schema.orderDetails.remove(orderDetail._id)
    Schema.orders.remove(order._id)

    logics.sales.currentOrderHistory.count()
  else
    -1



Apps.Merchant.salesInit.push ->
  logics.sales.tabOptions =
    source: logics.sales.currentOrderHistory
    currentSource: 'currentOrder'
    caption: 'tabDisplay'
    key: '_id'
    createAction: -> logics.sales.createNewOrderAndSelected()
    destroyAction: (instance) -> destroySaleAndDetail(instance._id)
    navigateAction: (instance) ->
      UserSession.set('currentOrder', instance._id)
      Session.set('currentOrder', logics.sales.currentOrder)