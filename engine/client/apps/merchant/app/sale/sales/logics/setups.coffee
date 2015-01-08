Apps.Merchant.salesInit.push (scope) ->
  scope.updateSelectProduct = (saleProduct)->
    order = Session.get('currentOrder')
    if !order then order = scope.createNewOrderAndSelected()

    order.currentProduct = saleProduct.product._id
    if saleProduct.unit then order.currentUnit = saleProduct.unit._id
    else (delete order.currentUnit if order.currentUnit)

    Session.set('currentOrder', order)
    Meteor.subscribe('orderDetails', order._id)

    if order.currentUnit
      Schema.orders.update order._id, $set: {currentProduct: order.currentProduct, currentUnit: order.currentUnit}
    else
      Schema.orders.update order._id, $set: {currentProduct: order.currentProduct}, $unset: {currentUnit: true}


  scope.updateSelectNewProduct = (product)->
    order = Session.get('currentOrder')
    if !order then order = scope.createNewOrderAndSelected()

    cross = scope.validation.getCrossProductQuality(product._id, order._id)
    maxQuality = (cross.product.availableQuality - cross.quality)

    order.currentProduct         = product._id
    order.currentQuality         = if maxQuality > 0 then 1 else 0
    order.currentPrice           = product.price
    order.currentTotalPrice      = product.price
    order.currentDiscountCash    = Number(0)
    order.currentDiscountPercent = Number(0)
    Session.set('currentOrder', order)
    Meteor.subscribe('orderDetails', order._id)

    Schema.orders.update order._id,
      $set:
        currentProduct        : order.currentProduct
        currentQuality        : order.currentQuality
        currentPrice          : order.currentPrice
        currentTotalPrice     : order.currentTotalPrice
        currentDiscountCash   : order.currentDiscountCash
        currentDiscountPercent: order.currentDiscountPercent

  scope.updateSaleDetail = (saleDetail, template)->
    if Session.get("salesEditingRow") and Session.get("salesEditingRowId")
      unitQuality = Number(template.ui.$editQuality.inputmask('unmaskedvalue'))
      unitPrice   = Number(template.ui.$editPrice.inputmask('unmaskedvalue'))
      discountCash = Number(template.ui.$editDiscountCash.inputmask('unmaskedvalue'))
      totalPrice = unitQuality * unitPrice
      if totalPrice > 0
        finalPrice = totalPrice - discountCash
        discountPercent = (discountCash * 100) / totalPrice
      else
        finalPrice = 0
        discountCash = 0
        discountPercent = 0

      optionDetail =
        unitQuality: unitQuality
        unitPrice: unitPrice
        quality: saleDetail.conversionQuality * unitQuality
        price: unitPrice/saleDetail.conversionQuality
        discountCash: discountCash
        discountPercent: discountPercent
        totalPrice: totalPrice
        finalPrice: finalPrice
      Schema.orderDetails.update saleDetail._id, $set: optionDetail
      console.log 'update'
      scope.reCalculateOrder(saleDetail.order)