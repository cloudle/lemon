reUpdateQualityOfOrderDetail = (newOrderDetail, oldOrderDetail) ->
  option={}
  option.quality      = oldOrderDetail.quality + newOrderDetail.quality
  option.totalPrice   = option.quality * oldOrderDetail.price
  option.discountCash = Math.round(option.totalPrice * oldOrderDetail.discountPercent/100)
  option.finalPrice   = option.totalPrice - option.discountCash
  Schema.orderDetails.update oldOrderDetail._id, $set: option , (error, result) -> console.log error if error

insertNewOrderDetail = (orderDetail)-> Schema.orderDetails.insert orderDetail, (error, result) -> console.log error if error

checkingAddOrderDetail= (orderDetail, orderDetails)->
  findOldOrderDetail =_.findWhere(orderDetails,
    {
      product         : orderDetail.product
      price           : orderDetail.price
      discountPercent : orderDetail.discountPercent
    })
  if findOldOrderDetail(orderDetail, orderDetails)
    reUpdateQualityOfOrderDetail(orderDetail, findOldOrderDetail)
  else
    insertNewOrderDetail(orderDetail)

logics.sales.addOrderDetail = (event, template) ->
  zone.run =>
    currentOrder = Order.findOne(Sky.global.currentOrder.id)
    if logics.sales.validation.orderDetail(currentOrder.data)
      orderDetails = Schema.orderDetails.find({order: order._id}).fetch()
      newOrderDetail = OrderDetail.newByOrder(currentOrder.data)

      #kiem tra orderDetail co ton tai hay ko, neu co cong so luong, tinh gia tong , ko thi them moi
      checkingAddOrderDetail(newOrderDetail, orderDetails)
      logics.sales.reCalculateOrder(currentOrder.data)








