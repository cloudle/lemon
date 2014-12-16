lemon.defineHyper Template.saleDetailEditor,
#  price: ->
#    Meteor.setTimeout ->
#      $("input[name='price']").change()
#    , 100
#    @price
#
#  quality: ->
#    Meteor.setTimeout ->
#      $("input[name='quality']").change()
#    , 100
#    @quality
#
#  discountCash: ->
#    Meteor.setTimeout ->
#      $("input[name='discountCash']").change()
#    , 100
#    @discountCash

  product: -> Schema.products.findOne(@product)
  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
  rendered: ->
    @ui.$editQuality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$editPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$editDiscountCash.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}

    @ui.$editQuality.val Session.get("salesEditingRow").unitQuality
    @ui.$editPrice.val Session.get("salesEditingRow").unitPrice
    @ui.$editDiscountCash.val Session.get("salesEditingRow").discountCash

    @ui.$editQuality.select()


  events:
    "keyup input[name]": (event, template) ->
      unitQuality = Number(template.ui.$editQuality.inputmask('unmaskedvalue'))
      unitPrice   = Number(template.ui.$editPrice.inputmask('unmaskedvalue'))
      discountCash = Number(template.ui.$editDiscountCash.inputmask('unmaskedvalue'))
      totalPrice = unitQuality * unitPrice
      if totalPrice > 0
        finalPrice = totalPrice - discountCash
        discountPercent = (discountCash * 100) / totalPrice
      else
        finalPrice = 0
        discountCash = 0
        discountPercent = 0

      optionDetail =
        unitQuality: unitQuality
        unitPrice: unitPrice
        quality: @conversionQuality * unitQuality
        price: unitPrice/@conversionQuality
        discountCash: discountCash
        discountPercent: discountPercent
        totalPrice: totalPrice
        finalPrice: finalPrice

      Schema.orderDetails.update @_id, $set: optionDetail
      logics.sales.reCalculateOrder(@order)

    "click .deleteOrderDetail": (event, template) ->
      Schema.orderDetails.remove @_id
      logics.sales.reCalculateOrder(@order)