checkProductInStockQuality = (orderDetails, branchProducts)->
  orderDetails = _.chain(orderDetails)
  .groupBy("branchProduct")
  .map (group, key) ->
    return {
      product      : group[0].product
      branchProduct: group[0].branchProduct
      quality      : _.reduce(group, ((res, current) -> res + current.quality), 0)
    }
  .value()
  try

    if branchProducts.length > 0 and orderDetails.length > 0
      for currentDetail in orderDetails
        currentProduct = _.findWhere(branchProducts, {_id: currentDetail.branchProduct})
        throw {message: "lỗi", item: currentDetail} if currentProduct?.availableQuality < currentDetail.quality
    else
      throw {message: "lỗi", item: 'Sai san pham.....'}
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

    saleDetail = SaleDetail.createSaleDetailByOrder(currentSale, sellingItem, productDetail, takenQuality)
    if saleDetail._id
      Schema.productDetails.update productDetail._id, $inc:{availableQuality: -takenQuality}
      Schema.products.update productDetail.product  , $inc:{availableQuality: -takenQuality}
      Schema.branchProductSummaries.update productDetail.branchProduct, $inc:{availableQuality: -takenQuality}

      transactionQuality += takenQuality
      if transactionQuality == sellingItem.quality then break

    else
      throw {error: 'Create saleDetail fail.', sale: currentSale}

  return transactionQuality == sellingItem.quality


createSaleAndSaleOrder = (order, orderDetails)->
  try
    currentSaleId = Schema.sales.insert Sale.newByOrder(order)
    if !currentSaleId then throw {error: 'Create sale fail.'}

    currentSale = Schema.sales.findOne(currentSaleId)
    productUpdateInc = {salesQuality: 0}

    for currentOrderDetail in orderDetails
      branchProduct = Schema.branchProductSummaries.findOne(currentOrderDetail.branchProduct)
      if !branchProduct then throw {error: 'Not Find product.'}; console.log 'Not Find product'
      if branchProduct.basicDetailModeEnabled is true
        saleDetail = SaleDetail.createSaleDetailByProduct(currentSale, currentOrderDetail)
        if !saleDetail._id then throw {error: 'Create saleDetail fail.', sale: currentSale}

      else
        importBasic = Schema.productDetails.find(
          {import: { $exists: false}, product: branchProduct.product, availableQuality: {$gt: 0}}, {sort: {'version.createdAt': 1}}
        ).fetch()
        importProductDetails = Schema.productDetails.find(
          {import: { $exists: true}, product: branchProduct.product, availableQuality: {$gt: 0}}, {sort: {'version.createdAt': 1}}
        ).fetch()
        combinedProductDetails = importBasic.concat(importProductDetails)
        subtractQualityOnSales(combinedProductDetails, currentOrderDetail, currentSale)

      productUpdateInc.salesQuality = currentOrderDetail.quality
    Schema.branchProductSummaries.update branchProduct._id, $inc: productUpdateInc
    Schema.products.update branchProduct.product, $set:{allowDelete : false}, $inc: productUpdateInc

    option = {status: true}
    if currentSale.paymentsDelivery == 1
      deliveryOption = Delivery.newBySale(order, currentSale)
      option.delivery = Schema.deliveries.insert deliveryOption

    Schema.userProfiles.update option.creator, $set:{allowDelete: false}
    Schema.userProfiles.update option.seller, $set:{allowDelete: false} if option.creator isnt option.seller
    Schema.sales.update currentSale._id, $set: option, (error, result) -> if error then console.log error
    return {sale: currentSale}

  catch error
    if error.error is 'Create saleDetail fail.'
      Schema.saleDetails.find({sale: error.sale._id}).forEach(
        (saleDetail)->
          Schema.productDetails.update saleDetail.productDetail, $inc:{availableQuality: saleDetail.quality} if saleDetail.productDetail
          Schema.branchProductSummaries.update saleDetail.branchProduct, $inc:{availableQuality: saleDetail.quality} if saleDetail.branchProduct
          Schema.products.update saleDetail.product, $inc:{availableQuality: saleDetail.quality} if saleDetail.product

          Schema.saleDetails.remove saleDetail._id
      )
      Schema.sales.remove error.sale._id
    return error




removeOrderAndOrderDetail = (order, userProfile, status)->
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

  Schema.orders.update({_id: order._id}, {$set: {status: status}})

#  Order.remove(order._id)
#  OrderDetail.remove({order: order._id})

updateCustomerByNewSales = (sale, orderDetails)->
  incCustomerOption = {
    debtBalance  : sale.debtBalanceChange
    saleDebt     : sale.debtBalanceChange
    saleTotalCash: sale.debtBalanceChange
  }
  productIds = _.uniq(_.pluck(orderDetails, 'product'))
  Schema.customers.update sale.buyer, $set:{allowDelete: false, billNo: sale.orderCode}, $inc: incCustomerOption, $push: {builtIn:{ $each: productIds, $slice: -50 }}


Meteor.methods
  finishOrder: (orderId) ->
    userProfile = Schema.userProfiles.findOne({user: @userId})
    if !userProfile then throw new Meteor.Error("User chưa đăng nhập."); return
    saleStaff = Role.hasPermission(userProfile._id, Apps.Merchant.TempPermissions.saleStaff.key)
    if !saleStaff then throw new Meteor.Error("Bạn không có phân quyền."); return
    currentOrder = Schema.orders.findOne({
      _id       : orderId
      status    : 0
      creator   : userProfile.user
      merchant  : userProfile.currentMerchant
      warehouse : userProfile.currentWarehouse})
    if !currentOrder then throw new Meteor.Error("Order không tồn tại."); return

    orderDetails = Schema.orderDetails.find({order: currentOrder._id}).fetch()
    if orderDetails.length < 1 then throw new Meteor.Error("Order rỗng."); return

    branchProduct_ids = _.union(_.pluck(orderDetails, 'branchProduct'))
    branchProducts = Schema.branchProductSummaries.find({_id: {$in: branchProduct_ids}}).fetch()
    branchProducts = _.where(branchProducts, {basicDetailModeEnabled: false})

    if branchProducts.length > 0
      result = checkProductInStockQuality(orderDetails, branchProducts)
      if result.error then throw new Meteor.Error(result.error.item)

    Schema.orders.update currentOrder._id, $set:{status: 1}
    if currentOrder = Schema.orders.findOne({_id: orderId, status: 1})
      result = createSaleAndSaleOrder(currentOrder, orderDetails)
      if result.error
        removeOrderAndOrderDetail(currentOrder, userProfile, 3)
        throw new Meteor.Error('createSaleAndDetail', result.error, result.sale)
      else
        #      productIds = _.uniq(_.pluck(orderDetails, 'product'))
        #      Schema.customers.update(sale.buyer, $push: {builtIn:{ $each: productIds, $slice: -50 }})

        removeOrderAndOrderDetail(currentOrder, userProfile, 2)
        updateCustomerByNewSales(result.sale, orderDetails)

        MetroSummary.updateMyMetroSummaryBy(['createSale'], result.sale._id)
        MetroSummary.updateMyMetroSummaryByProfitability()

        Meteor.call 'newSaleDefault', userProfile, result.sale._id
        return result.sale._id



