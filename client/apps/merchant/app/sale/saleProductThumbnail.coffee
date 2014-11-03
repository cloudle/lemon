lemon.defineWidget Template.saleProductThumbnail,
  avatarUrl: ->
    currentProduct = Schema.products.findOne(@product)
    AvatarImages.findOne(currentProduct?.image)?.url() ? undefined
  colorClasses: -> Helpers.RandomColor()
  qualityMeterStyle: ->
    currentProduct = Schema.products.findOne(@product)
    stockPercentage = currentProduct?.availableQuality / (currentProduct?.upperGapQuality ? 100)
    return {
      percent: stockPercentage * 100
      color: Helpers.ColorBetween(255, 0, 0, 135, 196, 57, stockPercentage, 3)
    }

  events:
    "dblclick .full-desc.trash": ->
      OrderDetail.remove(@_id)
      logics.sales.reCalculateOrder(@order)