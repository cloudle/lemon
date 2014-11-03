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

  name: -> Product.findOne(@product).data.name
  formatCurrency: (number) ->
    accounting.formatMoney(number, { symbol: 'VNĐ',  format: "%v %s", precision: 0 })
  formatNumber: (number) -> accounting.formatMoney(number, { format: "%v", precision: 0 })
  pad: (number) ->
    if number < 10 then '0' + number else number
  round: (number) -> Math.round(number)
  events:
    "dblclick .full-desc.trash": ->
      OrderDetail.remove(@_id)
      logics.sales.reCalculateOrder(@order)