Schema.add 'saleDetails', "SaleDetail", class SaleDetail
  @createSaleDetailByOrder = (currentSale, product, productDetail, quality)->
    option =
      sale          : currentSale._id
      product       : product.product
      productDetail : productDetail._id
      quality       : quality
      price         : product.price
      totalPrice    : (quality * product.price)
      returnQuality : 0
      export        : false
      status        : false

      unitQuality   : product.unitQuality
      unitPrice     : product.unitPrice
      conversionQuality: product.conversionQuality
    option.unit = product.unit if product.unit

    if currentSale.billDiscount
      if currentSale.discountCash == 0
        option.discountPercent = 0
      else
        option.discountPercent = currentSale.discountCash/(currentSale.totalPrice/100)
    else
      option.discountPercent = product.discountPercent
    option.finalPrice = option.totalPrice * (100 - option.discountPercent)/100
    option.discountCash   = option.totalPrice - option.finalPrice
    option.totalCogs = productDetail.importPrice * quality

    option._id = @schema.insert option
    option