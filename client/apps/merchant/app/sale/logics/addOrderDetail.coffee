newOrderDetail = (productId, quality, price, discountCash, currentOrder)->
  totalPrice      = quality * price
  discountPercent = discountCash/(totalPrice)*100
  option =
    order           : currentOrder._id
    product         : productId
    quality         : quality
    price           : price
    discountCash    : discountCash
    discountPercent : discountPercent
    totalPrice      : totalPrice
    finalPrice      : totalPrice - discountCash

reUpdateQualityOfOrderDetail = (newOrderDetail, oldOrderDetail) ->
  option={}
  option.quality      = oldOrderDetail.quality + newOrderDetail.quality
  option.totalPrice   = option.quality * oldOrderDetail.price
  option.discountCash = Math.round(option.totalPrice * oldOrderDetail.discountPercent/100)
  option.finalPrice   = option.totalPrice - option.discountCash
  OrderDetail.update oldOrderDetail._id, $set: option

insertNewOrderDetail = (orderDetail)-> OrderDetail.insert orderDetail

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

logics.sales.addOrderDetail = (productId, quality, price = null, discountCash = null)->
  zone.run =>
    currentOrder = logics.sales.currentOrder
    if !product = Schema.products.findOne(productId) then return console.log('productId không tồn tại.')
    if price is null then price = product.price
    if discountCash is null then discountCash = 0

    if logics.sales.validation.orderDetail(productId, quality, price, discountCash, product)
      orderDetails = Schema.orderDetails.find({order: currentOrder._id}).fetch()
      newOrderDetail = newOrderDetail(productId, quality, price, discountCash, currentOrder)

      #kiem tra orderDetail co ton tai hay ko, neu co cong so luong, tinh gia tong , ko thi them moi
      checkingAddOrderDetail(newOrderDetail, orderDetails)
      logics.sales.reCalculateOrder(currentOrder._id)








