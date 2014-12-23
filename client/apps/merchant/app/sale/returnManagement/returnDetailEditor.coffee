scope = logics.returnManagement

lemon.defineHyper Template.returnDetailEditor,
  productName: -> Schema.products.findOne(@product)?.name
  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit
  crossReturnAvailableQuality: ->
    if currentReturn = Session.get('currentReturn')
      returnDetail   = @
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


  rendered: ->
    @ui.$editQuality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$editPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$editDiscountCash.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}

    @ui.$editQuality.val Session.get("returnEditingRow").unitReturnQuality
    @ui.$editPrice.val Session.get("returnEditingRow").unitReturnsPrice
    @ui.$editDiscountCash.val Session.get("returnEditingRow").discountCash

    @ui.$editQuality.select()


  events:
    "keyup input[name]": (event, template) ->
      unitQuality = Math.abs(Number(template.ui.$editQuality.inputmask('unmaskedvalue')))
      unitPrice   = Math.abs(Number(template.ui.$editPrice.inputmask('unmaskedvalue')))
      discountCash = Math.abs(Number(template.ui.$editDiscountCash.inputmask('unmaskedvalue')))
      totalPrice = unitQuality * unitPrice
      if totalPrice > 0
        finalPrice = totalPrice - discountCash
        discountPercent = (discountCash * 100) / totalPrice
      else
        finalPrice = 0
        discountCash = 0
        discountPercent = 0

      optionDetail =
        unitReturnQuality: unitQuality
        unitReturnsPrice: unitPrice
        returnQuality: @conversionQuality * unitQuality
        price: unitPrice/@conversionQuality
        discountCash: discountCash
        discountPercent: discountPercent
        totalPrice: totalPrice
        finalPrice: finalPrice

      Schema.returnDetails.update @_id, $set: optionDetail
      scope.reCalculateReturn(@return)

    "click .deleteReturnDetail": (event, template) ->
      Schema.returnDetails.remove @_id
      scope.reCalculateReturn(@return)