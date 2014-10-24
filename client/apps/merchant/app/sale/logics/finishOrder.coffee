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
  Schema.sales.update currentSale.id, $set: option, (error, result) ->
    if error then console.log error
  currentSale.id

removeOrderAndOrderDetailAfterCreateSale = (orderId)->
  userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
  allTabs = Schema.orders.find(
    {
      creator   : userProfile.user
      merchant  : userProfile.currentMerchant
      warehouse : userProfile.currentWarehouse
    }).fetch()
  currentSource = _.findWhere(allTabs, {_id: userProfile.currentOrder})
  currentIndex = allTabs.indexOf(currentSource)
  currentLength = allTabs.length
  if currentLength > 1
    if currentLength is currentIndex+1
#      UserProfile.update {currentOrder: allTabs[currentIndex-1]._id}
    else
      console.log allTabs[currentIndex+1]
#      UserProfile.update {currentOrder: allTabs[currentIndex+1]._id}
    Order.removeAllOrderDetail(orderId)
  else
    Order.createOrderAndSelect()
    Order.removeAllOrderDetail(orderId)


calculateAndFinishOrder = (order, orderDetails)->
  result = logics.sales.validation.checkProductInStockQuality(order, orderDetails)
  if result.error then console.log result.error

  saleId = createSaleAndSaleOrder(order, orderDetails)
  removeOrderAndOrderDetailAfterCreateSale(order._id)
#  Notification.newSaleDefault(saleId)

checkingPaymentsDelivery = (event, template)->
  if Sky.global.currentOrder.data.paymentsDelivery is 1
    expire = template.ui.$deliveryDate.data('datepicker').dates[0]
    Sky.global.currentOrder.updateDeliveryDate(expire)


logics.sales.finishOrder = (event, template) ->
  zone.run =>
    currentOrder        = Order.findOne(Sky.global.currentOrder.id).data
    currentOrderDetails = OrderDetail.find({order: Sky.global.currentOrder.id}).data.fetch()

    checkingPaymentsDelivery(event, template)
    calculateAndFinishOrder(currentOrder, currentOrderDetails)