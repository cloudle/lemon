Apps.Merchant.salesInit.push ->
  logics.sales.tabOptions =
    source: logics.sales.currentOrderHistory
    currentSource: 'currentOrder'
    caption: 'tabDisplay'
    key: '_id'
    createAction: -> logics.sales.createNewOrderAndSelected()
    destroyAction: (instance) -> logics.sales.removeOrderAndOrderDetail(instance._id)
    navigateAction: (instance) -> logics.sales.selectOrder(instance._id)