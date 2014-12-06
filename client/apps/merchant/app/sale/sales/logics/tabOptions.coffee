destroySaleAndDetail = (scope, orderId)->
  order = Schema.orders.findOne({
    _id       : orderId
    creator   : Session.get('myProfile').user
    merchant  : Session.get('myProfile').currentMerchant
    warehouse : Session.get('myProfile').currentWarehouse})
  if order
    for orderDetail in Schema.orderDetails.find({order: order._id}).fetch()
      Schema.orderDetails.remove(orderDetail._id)
    Schema.orders.remove(order._id)

    scope.currentOrderHistory.count()
  else
    -1

Apps.Merchant.salesInit.push (scope) ->
  scope.tabOptions =
    source: scope.currentOrderHistory
    currentSource: 'currentOrder'
    caption: 'tabDisplay'
    key: '_id'
    createAction: -> scope.createNewOrderAndSelected()
    destroyAction: (instance) -> destroySaleAndDetail(scope, instance._id)
    navigateAction: (instance) ->
      UserSession.set('currentOrder', instance._id)
      Session.set('currentOrder', scope.currentOrder)