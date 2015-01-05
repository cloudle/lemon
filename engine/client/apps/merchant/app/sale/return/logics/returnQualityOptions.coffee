Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.returnQuality= ->
    product = Schema.saleDetails.findOne(Session.get('currentSale')?.currentProductDetail)
    if product
      findReturnDetail =_.findWhere(logics.returns.availableReturnDetails?.fetch(),{
        productDetail   : product.productDetail
        discountPercent : product.discountPercent
      })
      if findReturnDetail
        product.quality - (product.returnQuality + findReturnDetail.returnQuality)
      else
        product.quality - product.returnQuality

Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.returnQualityOptions =
    reactiveSetter: (val) -> Schema.sales.update(Session.get('currentSale')?._id, {$set: {currentQuality: val}})
    reactiveValue: -> Session.get('currentSale')?.currentQuality ? 0
    reactiveMax: -> logics.returns.returnQuality()
    reactiveMin: -> if logics.returns.returnQuality() > 0 then 1 else 0
    reactiveStep: -> 1