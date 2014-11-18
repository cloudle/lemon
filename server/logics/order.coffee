checkProductInStockQuality = (orderDetails, products)->
  orderDetails = _.chain(orderDetails)
  .groupBy("product")
  .map (group, key) ->
    return {
    product: key
    quality: _.reduce(group, ((res, current) -> res + current.quality), 0)
    }
  .value()
  try
    for currentDetail in orderDetails
      currentProduct = _.findWhere(products, {_id: currentDetail.product})
      if currentProduct.availableQuality < currentDetail.quality
        throw {message: "lỗi", item: currentDetail}

    return {}
  catch e
    return {error: e}

subtractQualityOnSales = (stockingItems, sellingItem , currentSale) ->
  transactionQuality = 0
  for productDetail in stockingItems
    requiredQuality = sellingItem.quality - transactionQuality
    if productDetail.availableQuality > requiredQuality
      takenQuality = requiredQuality
    else
      takenQuality = productDetail.availableQuality

    SaleDetail.createSaleDetailByOrder(currentSale, sellingItem, productDetail, takenQuality)
    Schema.productDetails.update productDetail._id, $inc:{availableQuality: -takenQuality}
    Schema.products.update productDetail.product  , $inc:{availableQuality: -takenQuality}

    transactionQuality += takenQuality
    if transactionQuality == sellingItem.quality then break
  return transactionQuality == sellingItem.quality


createSaleAndSaleOrder = (order, orderDetails)->
  currentSale = Schema.sales.findOne(Sale.insertByOrder(order))
  if !currentSale then throw new Meteor.Error("Create sale fail.")

  for currentOrderDetail in orderDetails
    productDetails = Schema.productDetails.find({product: currentOrderDetail.product, availableQuality: {$gt: 0}}).fetch()
    subtractQualityOnSales(productDetails, currentOrderDetail, currentSale)

  option = {status: true}
  if currentSale.paymentsDelivery == 1
    option.delivery = Delivery.insertBySale(order, currentSale)
  Schema.sales.update currentSale._id, $set: option, (error, result) -> if error then console.log error

  return currentSale


removeOrderAndOrderDetail = (order, userProfile)->
  allTabs = Order.myHistory(userProfile.user, userProfile.currentWarehouse, userProfile.currentMerchant).fetch()
  currentSource = _.findWhere(allTabs, {_id: userProfile.currentOrder})
  currentIndex = allTabs.indexOf(currentSource)
  currentLength = allTabs.length

  if currentLength > 1
    nextIndex = if currentIndex == currentLength - 1 then currentIndex - 1 else currentIndex + 1
    UserSession.set('currentOrder', allTabs[nextIndex]._id)
  else
    buyer = Customer.findOne(order.buyer).data
    UserSession.set('currentOrder', Order.createdNewBy(buyer, userProfile))
  Order.remove(order._id)
  OrderDetail.remove({order: order._id})




Meteor.methods
  finishOrder: (orderId) ->
    userProfile = Schema.userProfiles.findOne({user: @userId})
    if !userProfile then throw new Meteor.Error("User chưa đăng nhập."); return

    currentOrder = Schema.orders.findOne({
      _id       : orderId
      creator   : userProfile.user
      merchant  : userProfile.currentMerchant
      warehouse : userProfile.currentWarehouse})
    if !currentOrder then throw new Meteor.Error("Order không tồn tại."); return

    orderDetails = Schema.orderDetails.find({order: currentOrder._id}).fetch()
    if orderDetails.length < 1 then throw new Meteor.Error("Order rỗng."); return

    product_ids = _.union(_.pluck(orderDetails, 'product'))
    products = Schema.products.find({_id: {$in: product_ids}}).fetch()
    result = checkProductInStockQuality(orderDetails, products)
    if result.error then throw new Meteor.Error(result.error)

    sale = createSaleAndSaleOrder(currentOrder, orderDetails)
    if sale then removeOrderAndOrderDetail(currentOrder, userProfile)

    return sale._id
