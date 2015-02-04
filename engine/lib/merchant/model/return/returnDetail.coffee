Schema.add 'returnDetails', "ReturnDetail", class ReturnDetail
  @newByReturn : (returnId, saleId)->
    sale = Schema.sales.findOne(saleId)
    saleDetail = Schema.saleDetails.findOne(sale.currentProductDetail)
    option =
      return          : returnId
      sale            : saleDetail.sale
      saleDetail      : saleDetail._id
      product         : saleDetail.product
      branchProduct   : saleDetail.branchProduct
      productDetail   : saleDetail.productDetail
      name            : saleDetail.name
      skulls          : saleDetail.skulls
      returnQuality   : sale.currentQuality
      price           : saleDetail.price
      submit          : false
      discountPercent : saleDetail.discountPercent
      discountCash    : Math.round(saleDetail.price * sale.currentQuality * saleDetail.discountPercent)
      finalPrice      : Math.round(saleDetail.price * sale.currentQuality * (100 - saleDetail.discountPercent)/100)
    option







