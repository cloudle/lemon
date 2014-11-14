reCalculateOrderDetail= (orderDetail, quality)->
  option = {quality: orderDetail.quality + quality}
  option.totalPrice   = option.quality * orderDetail.price
  option.discountCash = Math.round(option.totalPrice * orderDetail.discountPercent/100)
  option.finalPrice   = option.totalPrice - option.discountCash
  Schema.orderDetails.update(orderDetail._id, {$set: option})
  logics.sales.reCalculateOrder(orderDetail.order)


lemon.defineWidget Template.saleProductThumbnail,
  avatarUrl: ->
    currentProduct = Schema.products.findOne(@product)
    AvatarImages.findOne(currentProduct?.image)?.url() ? undefined
  meterStyle: ->
    cross = logics.sales.validation.getCrossProductQuality(@product, @order)
    stockPercentage = (cross.product?.availableQuality - cross.quality) / (cross.product?.upperGapQuality ? 100)
    return {
      percent: stockPercentage * 100
      color: Helpers.ColorBetween(255, 0, 0, 135, 196, 57, stockPercentage, 3)
    }

  events:
    "click .trash": (event, template) ->
      OrderDetail.remove(@_id)
      logics.sales.reCalculateOrder(@order)

    "click .command-button.up": ->
      cross = logics.sales.validation.getCrossProductQuality(@product, @order)
      reCalculateOrderDetail(@, 1) if (cross.product.availableQuality - cross.quality) > 0

    "click .command-button.down": -> reCalculateOrderDetail(@, -1) if @quality > 1