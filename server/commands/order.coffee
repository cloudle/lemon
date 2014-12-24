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
    if products.length > 0
      for currentDetail in orderDetails
        currentProduct = _.findWhere(products, {_id: currentDetail.product})
        throw {message: "lỗi", item: currentDetail} if currentProduct?.availableQuality < currentDetail.quality
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
  currentSaleId = Schema.sales.insert Sale.newByOrder(order)
  if !currentSaleId then throw new Meteor.Error("Create sale fail.")
  currentSale = Schema.sales.findOne(currentSaleId)

  for currentOrderDetail in orderDetails
    product = Schema.products.findOne(currentOrderDetail.product)
    if !product then throw new Meteor.Error("Not Find product.")
    if product.basicDetailModeEnabled is true
      SaleDetail.createSaleDetailByProduct(currentSale, currentOrderDetail)
    else
      importBasic = Schema.productDetails.find(
        {import: { $exists: false}, product: product._id, availableQuality: {$gt: 0}}, {sort: {'version.createdAt': 1}}
      ).fetch()
      importProductDetails = Schema.productDetails.find(
        {import: { $exists: true}, product: product._id, availableQuality: {$gt: 0}}, {sort: {'version.createdAt': 1}}
      ).fetch()
      combinedProductDetails = importBasic.concat(importProductDetails)
      subtractQualityOnSales(combinedProductDetails, currentOrderDetail, currentSale)

  option = {status: true}
  if currentSale.paymentsDelivery == 1
    deliveryOption = Delivery.newBySale(order, currentSale)
    option.delivery = Schema.deliveries.insert deliveryOption

  Schema.userProfiles.update option.creator, $set:{allowDelete: false}
  Schema.userProfiles.update option.seller, $set:{allowDelete: false} if option.creator isnt option.seller
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
    UserSession.set('currentOrder', Order.createdNewBy(buyer, userProfile)._id)
  Order.remove(order._id)
  OrderDetail.remove({order: order._id})

updateCustomerByNewSales = (sale, profile)->
  incCustomerOption = {
    debtBalance  : sale.debtBalanceChange
    saleDebt     : sale.debtBalanceChange
    saleTotalCash: sale.debtBalanceChange
  }
  Schema.customers.update sale.buyer, $inc: incCustomerOption


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
    products = _.where(products, {basicDetailModeEnabled: false})

    result = checkProductInStockQuality(orderDetails, products)
    if result.error then throw new Meteor.Error(result.error.item)

    sale = createSaleAndSaleOrder(currentOrder, orderDetails)
    if sale
      productIds = _.uniq(_.pluck(orderDetails, 'product'))
      Schema.customers.update(sale.buyer, $push: {builtIn:{ $each: productIds, $slice: -50 }})

      removeOrderAndOrderDetail(currentOrder, userProfile)
      updateCustomerByNewSales(sale, userProfile)

    Meteor.call 'newSaleDefault', userProfile, sale._id
    return sale._id
