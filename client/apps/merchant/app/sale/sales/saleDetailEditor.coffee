lemon.defineHyper Template.saleDetailEditor,
  finalPrice: -> @price * @quality - @discountCash
  product: -> Schema.products.findOne(@product)
  rendered: ->
    @ui.$quality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$price.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$discount.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}

    @ui.$quality.select()

  events:
    "keypress [name='quality']": (event, template) ->
      if event.which is 13 #ENTER
        Schema.orderDetails.update(@_id, {$set: {quality: template.ui.$quality.inputmask('unmaskedvalue')}})