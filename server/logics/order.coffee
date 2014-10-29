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
  unless currentSale = Sale.findOne(Sale.insertByOrder(order)) then return null
  for currentOrderDetail in orderDetails
    productDetails = Schema.productDetails.find({product: currentOrderDetail.product}).fetch()
    subtractQualityOnSales(productDetails, currentOrderDetail, currentSale.data)

  option = {status: true}
  if currentSale.data.paymentsDelivery == 1
    option.delivery = Delivery.insertBySale(order, currentSale.data)
  Sale.update currentSale.id, $set: option, (error, result) ->
    if error then console.log error
  currentSale.id

removeOrderAndOrderDetailAfterCreateSale = (orderId)->
  userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
  allTabs = logics.sales.currentOrderHistory.fetch()
  currentSource = _.findWhere(allTabs, {_id: userProfile.currentOrder})
  currentIndex = allTabs.indexOf(currentSource)
  currentLength = allTabs.length
  if currentLength > 1
    if currentLength is currentIndex+1
      logics.sales.selectOrder(allTabs[currentIndex-1]._id)
    else
      logics.sales.selectOrder(allTabs[currentIndex+1]._id)
    logics.sales.removeOrderAndOrderDetail(orderId)
  else
    logics.sales.createNewOrderAndSelected()
    logics.sales.removeOrderAndOrderDetail(orderId)


Meteor.methods
  finishOrder: (orderId) ->
    userProfile = Schema.userProfiles.findOne({user: @userId})
    if !userProfile then throw new Meteor.Error("User chưa đăng nhập.")

    currentOrder = Schema.orders.findOne({
      _id       : orderId
      creator   : userProfile.user
      merchant  : userProfile.currentMerchant
      warehouse : userProfile.currentWarehouse})
    if !currentOrder then throw new Meteor.Error("Order không tồn tại.")

    currentOrderDetails = Schema.orderDetails.find({order: currentOrder._id}).fetch()
    if currentOrderDetails.length < 1 then throw new Meteor.Error("Order rỗng.")

    product_ids = _.union(_.pluck(currentOrderDetails, 'product'))
    products = Schema.products.find({_id: {$in: product_ids}}).fetch()
    result = checkProductInStockQuality(currentOrderDetails, products)
    if result.error then throw new Meteor.Error(result.error)

    saleId = createSaleAndSaleOrder(currentOrder, currentOrderDetails)
    removeOrderAndOrderDetailAfterCreateSale(orderId)

    return @userId







