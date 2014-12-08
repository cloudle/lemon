lemon.defineHyper Template.saleDetailEditor,
  price: ->
    Meteor.setTimeout ->
      console.log 'updating'
      $("input[name='price']").change()
    , 100
    @price
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
    "keypress input[name]": (event, template) ->
      if event.which is 13 #ENTER
        quality = template.ui.$quality.inputmask('unmaskedvalue')
        price = template.ui.$price.inputmask('unmaskedvalue')
        discountCash = template.ui.$discountCash.inputmask('unmaskedvalue')
        totalPrice = price * quality
        finalPrice = totalPrice - discountCash
        discountPercent = (discountCash * 100) / totalPrice

        Schema.orderDetails.update @_id,
          $set:
            quality: quality
            price: price
            discountCash: discountCash
            discountPercent: discountPercent
            totalPrice: totalPrice
            finalPrice: finalPrice

        logics.sales.reCalculateOrder(@order)