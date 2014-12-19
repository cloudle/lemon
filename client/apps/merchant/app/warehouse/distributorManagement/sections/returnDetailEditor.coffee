lemon.defineHyper Template.distributorManagementReturnDetailEditor,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit
  crossReturnAvailableQuality: ->
    currentProduct = Schema.productDetails.find({import: @import, product: @product}).fetch()
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

  rendered: ->
    @ui.$returnQuality.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$returnQuality.val Session.get("distributorManagementReturnDetailEditingRow").unitReturnQuality

    @ui.$returnPrice.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$returnPrice.val Session.get("distributorManagementReturnDetailEditingRow").unitReturnsPrice

    @ui.$returnQuality.select()

  events:
    "keypress input[name]": (event, template) ->
      #TODO: Kiem tra trung ten & unit!
      returnQuality = Number(template.ui.$returnQuality.inputmask('unmaskedvalue'))
      console.log returnQuality
      returnPrice = Number(template.ui.$returnPrice.inputmask('unmaskedvalue'))
      returnPrice = 0 if returnPrice < 0

      returnDetailOption =
        unitReturnQuality : returnQuality - @unitReturnQuality
        unitReturnsPrice  : returnPrice - @unitReturnsPrice
        returnQuality     : (returnQuality*@conversionQuality) - @returnQuality
      returnDetailOption.finalPrice = (returnQuality*returnPrice) - @finalPrice
      price = returnDetailOption.unitReturnsPrice/(returnDetailOption.unitReturnQuality * @conversionQuality)

      console.log returnDetailOption
      console.log price
      Schema.returnDetails.update @_id, $set:{price: price}, $inc: returnDetailOption

      finalPrice = 0; Schema.returnDetails.find({return: @return}).forEach((detail)-> finalPrice += detail.finalPrice)
      Schema.returns.update @return, $set:{totalPrice: finalPrice, finallyPrice: finalPrice}

      if event.which is 13
        Session.set("distributorManagementReturnDetailEditingRow")
        Session.set("distributorManagementReturnDetailEditingRowId")



