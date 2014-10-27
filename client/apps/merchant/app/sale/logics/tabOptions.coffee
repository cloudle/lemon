logics.sales.tabOptions = ->
  source: 'orderHistory'
  currentSource: 'currentOrder'
  caption: 'tabDisplay'
  key: '_id'
  createAction: -> Order.createOrderAndSelect()
  destroyAction: (instance) -> Order.removeAllOrderDetail(instance._id)
  navigateAction: (instance) -> UserProfile.update {currentOrder: instance._id}

