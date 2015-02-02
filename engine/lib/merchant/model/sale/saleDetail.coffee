Schema.add 'saleDetails', "SaleDetail", class SaleDetail
  @createSaleDetailByOrder = (currentSale, product, productDetail, quality)->
    option =
      sale          : currentSale._id
      product       : product.product
      branchProduct : productDetail.branchProduct
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
#    option.totalCogs = Math.round(quality * productDetail.importPrice)

    if currentSale.billDiscount
      if currentSale.discountCash == 0
        option.discountPercent = 0
      else
        option.discountPercent = currentSale.discountCash/(currentSale.totalPrice/100)
    else
      option.discountPercent = product.discountPercent

    option.finalPrice   = option.totalPrice * (100 - option.discountPercent)/100
    option.discountCash = option.totalPrice - option.finalPrice
    option._id = @schema.insert option
    option

  @createSaleDetailByProduct = (currentSale, orderDetail)->
    option =
      sale             : currentSale._id
      product          : orderDetail.product
      branchProduct    : orderDetail.branchProduct
      quality          : orderDetail.quality
      price            : orderDetail.price
      totalPrice       : orderDetail.totalPrice
      finalPrice       : orderDetail.finalPrice
      discountCash     : orderDetail.discountCash
      discountPercent  : orderDetail.discountPercent
      returnQuality    : 0
      export           : false
      status           : false
      unitQuality      : orderDetail.unitQuality
      unitPrice        : orderDetail.unitPrice
      conversionQuality: orderDetail.conversionQuality

    if orderDetail.unit
      option.unit = orderDetail.unit
#      option.totalCogs = Math.round((orderDetail.quality/orderDetail.conversionQuality) * Schema.productUnits.findOne(orderDetail.unit)?.importPrice)
    else
#      option.totalCogs = Math.round((orderDetail.quality/orderDetail.conversionQuality) * Schema.products.findOne(orderDetail.product)?.importPrice)

    option._id = @schema.insert option
    option