logics.sales.selectOrder = (orderId)-> UserSession.set('currentOrder', orderId)

logics.sales.removeOrderAndOrderDetail = (orderId)->
  try
    order = Schema.orders.findOne(orderId)
    if order
      for orderDetail in Schema.orderDetails.find({order: order._id}).fetch()
        Schema.orderDetails.remove(orderDetail._id)
      Schema.orders.remove(order._id)
    else
      throw {error: true, message: "Không Tìm Thấy Order"}
    return {error: false, message: "Đã Xóa Order"}
  catch e
    return e

