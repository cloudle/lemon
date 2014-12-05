Apps.Merchant.salesInit.push (scope) ->
  scope.updateSelectNewProduct = (scope, product)->
    if scope.currentOrder then orderId = scope.currentOrder._id
    else orderId = scope.createNewOrderAndSelected()

    cross = scope.validation.getCrossProductQuality(product._id, orderId)
    maxQuality = (cross.product.availableQuality - cross.quality)
    Schema.orders.update orderId,
      $set:
        currentProduct        : product._id
        currentQuality        : if maxQuality > 0 then 1 else 0
        currentPrice          : product.price
        currentTotalPrice     : product.price
        currentDiscountCash   : Number(0)
        currentDiscountPercent: Number(0)