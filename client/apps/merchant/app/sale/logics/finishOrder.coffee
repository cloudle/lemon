#subtractQualityOnSales = (stockingItems, sellingItem , currentSale) ->
#  transactionQuality = 0
#  for productDetail in stockingItems
#    requiredQuality = sellingItem.quality - transactionQuality
#    if productDetail.availableQuality > requiredQuality
#      takenQuality = requiredQuality
#    else
#      takenQuality = productDetail.availableQuality
#
#    SaleDetail.createSaleDetailByOrder(currentSale, sellingItem, productDetail, takenQuality)
#    Schema.productDetails.update productDetail._id, $inc:{availableQuality: -takenQuality}
#    Schema.products.update productDetail.product  , $inc:{availableQuality: -takenQuality}
#
#    transactionQuality += takenQuality
#    if transactionQuality == sellingItem.quality then break
#  return transactionQuality == sellingItem.quality
#
#createSaleAndSaleOrder = (order, orderDetails)->
#  unless currentSale = Sale.findOne(Sale.insertByOrder(order)) then return null
#  for currentOrderDetail in orderDetails
#    productDetails = Schema.productDetails.find({product: currentOrderDetail.product}).fetch()
#    subtractQualityOnSales(productDetails, currentOrderDetail, currentSale.data)
#
#  option = {status: true}
#  if currentSale.data.paymentsDelivery == 1
#    option.delivery = Delivery.insertBySale(order, currentSale.data)
#  Sale.update currentSale.id, $set: option, (error, result) ->
#    if error then console.log error
#  currentSale.id
#
#removeOrderAndOrderDetailAfterCreateSale = (orderId)->
#  userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
#  allTabs = logics.sales.currentOrderHistory.fetch()
#  currentSource = _.findWhere(allTabs, {_id: userProfile.currentOrder})
#  currentIndex = allTabs.indexOf(currentSource)
#  currentLength = allTabs.length
#  if currentLength > 1
#    if currentLength is currentIndex+1
#      logics.sales.selectOrder(allTabs[currentIndex-1]._id)
#    else
#      logics.sales.selectOrder(allTabs[currentIndex+1]._id)
#    logics.sales.removeOrderAndOrderDetail(orderId)
#  else
#    logics.sales.createNewOrderAndSelected()
#    logics.sales.removeOrderAndOrderDetail(orderId)
#
#
#logics.sales.finishOrder = (orderId) ->
#  currentOrder = Order.findOne(orderId).data
#  return console.log('Không tìm thấy Order') if !currentOrder
#  currentOrderDetails = OrderDetail.find({order: orderId}).data.fetch()
#  return console.log('Order rỗng') if currentOrderDetails.length < 1
#
#  result = logics.sales.validation.checkProductInStockQuality(currentOrder, currentOrderDetails)
#  if result.error then console.log result.error
#
#  saleId = createSaleAndSaleOrder(currentOrder, currentOrderDetails)
#  removeOrderAndOrderDetailAfterCreateSale(orderId)
#  #  Notification.newSaleDefault(saleId)