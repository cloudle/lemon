Apps.Merchant.returnManagementInit.push (scope) ->
  scope.crossReturnAvailableQuality = (currentReturn, returnDetail)->
    if currentReturn.customer
      currentProduct = []
      Schema.sales.find({buyer: currentReturn.customer}).forEach(
        (sale)->
          Schema.saleDetails.find({sale: sale._id, product: returnDetail.product}).forEach(
            (saleDetail)-> currentProduct.push saleDetail
          )
      )
      sameProducts = Schema.returnDetails.find({return: @return, product: @product}).fetch()

      crossProductQuality = 0
      currentProductQuality = 0
      crossProductQuality += item.returnQuality for item in sameProducts
      currentProductQuality += (item.quality - item.returnQuality) for item in currentProduct

      crossAvailable = currentProductQuality - crossProductQuality
      if crossAvailable < 0
        crossAvailable = Math.ceil(Math.abs(crossAvailable/@conversionQuality))*(-1)
      else
        Math.ceil(Math.abs(crossAvailable/@conversionQuality))

      return {
        crossAvailable: crossAvailable
        isValid: crossAvailable > 0
        invalid: crossAvailable < 0
        errorClass: if crossAvailable >= 0 then '' else 'errors'
      }

    if currentReturn.distributor
      currentProduct = Schema.productDetails.find({product: @product}).fetch()
      sameProducts = Schema.returnDetails.find({return: @return, productDetail: @productDetail}).fetch()
      crossProductQuality = 0
      currentProductQuality = 0
      crossProductQuality += item.returnQuality for item in sameProducts
      currentProductQuality += item.availableQuality for item in currentProduct

      crossAvailable = currentProductQuality - crossProductQuality
      if crossAvailable < 0
        crossAvailable = Math.ceil(Math.abs(crossAvailable/@conversionQuality))*(-1)
      else
        Math.ceil(Math.abs(crossAvailable/@conversionQuality))

      return {
        crossAvailable: crossAvailable
        isValid: crossAvailable > 0
        invalid: crossAvailable < 0
        errorClass: if crossAvailable >= 0 then '' else 'errors'
      }