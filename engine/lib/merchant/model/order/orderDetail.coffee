Schema.add 'orderDetails', "OrderDetail", class OrderDetail
  @findBy: (orderId)-> @schema.find({order: orderId})


  @newByOrder: (order)->
    option =
      order           : order._id
      product         : order.currentProduct
      quality         : order.currentQuality
      price           : order.currentPrice
      discountCash    : order.currentDiscountCash
      discountPercent : order.currentDiscountCash/(order.currentQuality * order.currentPrice)*100
      totalPrice      : order.currentQuality * order.currentPrice
      finalPrice      : order.currentQuality * order.currentPrice - order.currentDiscountCash