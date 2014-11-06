lemon.defineWidget Template.stockThumbnail,
  canDelete: -> @totalQuality == 0
  avatarUrl: -> undefined
  meterStyle: ->
    stockPercentage = @availableQuality / (@upperGapQuality ? 100)
    return {
      percent: stockPercentage * 100
      color: Helpers.ColorBetween(255, 0, 0, 135, 196, 57, stockPercentage, 3)
    }
  events:
    "click .full-desc.trash": ->
      deletingProduct = Schema.products.findOne(@_id)
      Schema.products.remove(@_id)