lemon.defineWidget Template.saleProductThumbnail,
  avatarUrl: ->
    currentProduct = Schema.products.findOne(@product)
    AvatarImages.findOne(currentProduct?.image)?.url() ? undefined
  meterStyle: ->
    currentProduct = Schema.products.findOne(@product)
    sameProducts = Schema.orderDetails.find({product: @product, order: @order}).fetch()
    crossProductQuality = 0
    crossProductQuality += item.quality for item in sameProducts

    stockPercentage = (currentProduct?.availableQuality - crossProductQuality) / (currentProduct?.upperGapQuality ? 100)
    return {
      percent: stockPercentage * 100
      color: Helpers.ColorBetween(255, 0, 0, 135, 196, 57, stockPercentage, 3)
    }

  events:
    "click .trash": ->
      OrderDetail.remove(@_id)
      logics.sales.reCalculateOrder(@order)