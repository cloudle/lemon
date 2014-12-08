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
    @ui.$discount.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}

    @ui.$quality.select()

  events:
    "keypress input[name]": (event, template) ->
      if event.which is 13 #ENTER
        quality = template.ui.$quality.inputmask('unmaskedvalue')
        price = template.ui.$price.inputmask('unmaskedvalue')
        discount = template.ui.$discount.inputmask('unmaskedvalue')
        finalPrice = price * quality - discount

        Schema.orderDetails.update @_id,
          $set:
            quality: quality
            price: price
            discount: discount
            finalPrice: finalPrice