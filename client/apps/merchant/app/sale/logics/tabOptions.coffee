logics.sales.tabOptions =
#  source: logics.sales.currentOrderHistory.fetch()
#  currentSource: logics.sales.currentOrder

  source: 'orderHistory'
  currentSource: 'currentOrder'
  caption: 'tabDisplay'
  key: '_id'
  createAction: -> logics.sales.createNewOrderAndSelected()
  destroyAction: (instance) -> logics.sales.removeOrderAndOrderDetail(instance._id)
  navigateAction: (instance) -> logics.sales.selectOrder(instance._id)

