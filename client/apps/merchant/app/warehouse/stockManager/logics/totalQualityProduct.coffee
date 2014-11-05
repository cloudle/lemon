logics.stockManager.totalQualityProduct = ->
  total = 0
  if logics.stockManager.availableProducts
    for item in logics.stockManager.availableProducts.fetch()
      total += item.totalQuality
  total
