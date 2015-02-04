optionOrderDetail = (currentOrder, product, branchProduct, productUnit,  quality, price, discountCash)->
  totalPrice      = quality * price
  if discountCash <= 0
    discountPercent = 0
  else
    discountPercent = discountCash/(totalPrice)*100
  option =
    order            : currentOrder._id
    product          : product._id
    branchProduct    : branchProduct._id
    unitQuality      : quality
    unitPrice        : price/quality
    discountCash     : discountCash
    discountPercent  : discountPercent
    totalPrice       : totalPrice
    finalPrice       : totalPrice - discountCash
    styles           : Helpers.RandomColor()

  if productUnit
    option.unit               = productUnit._id
    option.conversionQuality  = productUnit.conversionQuality
  else
    option.conversionQuality  = 1

  option.quality = option.conversionQuality * quality
  option.price   = price/option.quality

  return option

reUpdateQualityOfOrderDetail = (newOrderDetail, oldOrderDetail) ->
  option={}
  option.unitQuality  = oldOrderDetail.unitQuality + newOrderDetail.unitQuality
  option.quality      = option.unitQuality * oldOrderDetail.conversionQuality
  option.totalPrice   = option.quality * oldOrderDetail.price
  option.discountCash = Math.round(option.totalPrice * oldOrderDetail.discountPercent/100)
  option.finalPrice   = option.totalPrice - option.discountCash
  Schema.orderDetails.update oldOrderDetail._id, $set: option
  oldOrderDetail._id

checkingAddOrderDetail= (newOrderDetail, orderDetails)->
  existedQuery =
    product           : newOrderDetail.product
    price             : newOrderDetail.price
    discountPercent   : newOrderDetail.discountPercent
    conversionQuality : newOrderDetail.conversionQuality
  existedQuery.unit = newOrderDetail.unit if newOrderDetail.unit

  if findOldOrderDetail =_.findWhere(orderDetails, existedQuery)
    orderId = reUpdateQualityOfOrderDetail(newOrderDetail, findOldOrderDetail)
  else
    orderId = Schema.orderDetails.insert newOrderDetail
  return orderId

Apps.Merchant.salesInit.push ->
  logics.sales.addOrderDetail = (productId, unitId = null, quality = 1, price = null, discountCash = null)->
    if currentOrder = Session.get('currentOrder')
      if !product = Schema.products.findOne(productId) then return console.log('productId không tồn tại.')
      branchProduct = Schema.branchProductSummaries.findOne({product: productId, merchant: currentOrder.merchant})

      if unitId
        productUnit = Schema.productUnits.findOne({_id: unitId, product: productId})
        if !productUnit then return console.log('unitId không tồn tại.')
        branchProductUnit = Schema.branchProductUnits.findOne({productUnit: unitId, merchant: currentOrder.merchant})
      else productUnit = undefined

      if product.buildInProduct and productUnit?.buildInProductUnit
        buildInProductUnit = Schema.buildInProductUnits.findOne(productUnit.buildInProductUnit)
        productUnit.conversionQuality = buildInProductUnit.conversionQuality

      if price is null or price < 0
        if productUnit then price = branchProductUnit.price ? productUnit.price
        else price = branchProduct.price ? product.price

      if discountCash is null || discountCash < 0 then discountCash = 0
      else if discountCash > quality * price then discountCash = quality * price


  #      if logics.sales.validation.orderDetail(productId, quality, price, discountCash, product)

      newOrderDetail = optionOrderDetail(currentOrder, product, branchProduct, productUnit,  quality, price, discountCash)
      console.log newOrderDetail
      #kiem tra orderDetail co ton tai hay ko, neu co cong so luong, tinh gia tong , ko thi them moi
      orderDetails = Schema.orderDetails.find({order: currentOrder._id}).fetch()
      orderId = checkingAddOrderDetail(newOrderDetail, orderDetails)
      logics.sales.reCalculateOrder(currentOrder._id)
      return orderId