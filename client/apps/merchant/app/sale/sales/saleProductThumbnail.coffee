lemon.defineWidget Template.saleProductThumbnail,
  avatarUrl: ->
    currentProduct = Schema.products.findOne(@product)
    AvatarImages.findOne(currentProduct?.image)?.url() ? undefined
  meterStyle: ->
    cross = logics.sales.validation.getCrossProductQuality(@)
    stockPercentage = (cross.product?.availableQuality - cross.quality) / (cross.product?.upperGapQuality ? 100)
    return {
      percent: stockPercentage * 100
      color: Helpers.ColorBetween(255, 0, 0, 135, 196, 57, stockPercentage, 3)
    }

  events:
    "click .trash": ->
      OrderDetail.remove(@_id)
      logics.sales.reCalculateOrder(@order)
    "click .command-button.up": ->
      cross = logics.sales.validation.getCrossProductQuality(@)
      Schema.orderDetails.update(@_id, {$set: {quality: @quality + 1}}) if (cross.product.availableQuality - cross.quality) > 0
    "click .command-button.down": ->
      Schema.orderDetails.update(@_id, {$set: {quality: @quality - 1}}) if @quality > 1