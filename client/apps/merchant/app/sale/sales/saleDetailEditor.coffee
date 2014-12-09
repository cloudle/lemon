lemon.defineHyper Template.saleDetailEditor,
  price: ->
    Meteor.setTimeout ->
      $("input[name='price']").change()
    , 100
    @price

  quality: ->
    Meteor.setTimeout ->
      $("input[name='quality']").change()
    , 100
    @quality

  discountCash: ->
    Meteor.setTimeout ->
      $("input[name='discountCash']").change()
    , 100
    @discountCash


  product: -> Schema.products.findOne(@product)
  rendered: ->
    @ui.$quality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$price.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$discountCash.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}

    @ui.$quality.select()

  events:
    "keyup input[name]": (event, template) ->
      quality = Number(template.ui.$quality.inputmask('unmaskedvalue'))
      price = Number(template.ui.$price.inputmask('unmaskedvalue'))
      discountCash = Number(template.ui.$discountCash.inputmask('unmaskedvalue'))
      totalPrice = price * quality
      if totalPrice > 0
        finalPrice = totalPrice - discountCash
        discountPercent = (discountCash * 100) / totalPrice
      else
        finalPrice = 0
        discountCash = 0
        discountPercent = 0

      Schema.orderDetails.update @_id,
        $set:
          quality: quality
          price: price
          discountCash: discountCash
          discountPercent: discountPercent
          totalPrice: totalPrice
          finalPrice: finalPrice

      logics.sales.reCalculateOrder(@order)

    "click .deleteOrderDetail": (event, template) ->
      Schema.orderDetails.remove @_id
      logics.sales.reCalculateOrder(@order)