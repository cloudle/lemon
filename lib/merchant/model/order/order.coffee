Schema.add 'orders', class Order
  updateContactName     : (value)-> @schema.update(@id, {$set:{contactName:     value}})
  updateContactPhone    : (value)-> @schema.update(@id, {$set:{contactPhone:    value}})
  updateDeliveryAddress : (value)-> @schema.update(@id, {$set:{deliveryAddress: value}})
  updateComment         : (value)-> @schema.update(@id, {$set:{comment:         value}})
  updateDeliveryDate    : (expire)->
    if expire > (new Date)
      expireDate = new Date(expire.getFullYear(), expire.getMonth(), expire.getDate())
      option = $set: {deliveryDate: expireDate}
    else
      option = $unset: {deliveryDate: true}
    @schema.update(@id, option)

  @createOrder: ()->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    buyer = Schema.customers.findOne({parentMerchant: userProfile.parentMerchant})

    option =
      merchant               : userProfile.currentMerchant
      warehouse              : userProfile.currentWarehouse
      creator                : userProfile.user
      seller                 : userProfile.user
      buyer                  : buyer._id ? 'null'
      currentProduct         : "null"
      currentQuality         : 0
      currentPrice           : 0
      currentDiscountCash    : 0
      currentDiscountPercent : 0
      orderCode              : createOrderCode()
      tabDisplay             : 'New Order'
      paymentsDelivery       : 0
      paymentMethod          : 0
      discountCash           : 0
      discountPercent        : 0
      productCount           : 0
      saleCount              : 0
      totalPrice             : 0
      finalPrice             : 0
      deposit                : 0
      debit                  : 0
      billDiscount           : false
      status                 : 0
      currentDeposit         : 0

    if buyer then option.tabDisplay = Sky.helpers.respectName(buyer.name, buyer.gender)
    option._id = Schema.orders.insert option
    option

  @createOrderAndSelect: -> order = @createOrder(); UserProfile.update {currentOrder: order._id}; order

  @removeAllOrderDetail: (orderId)->
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
