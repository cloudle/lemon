lemon.defineWidget Template.returnProductThumbnail,
  avatarUrl: ->
    currentProduct = Schema.products.findOne(@product)
    AvatarImages.findOne(currentProduct?.image)?.url() ? undefined

  events:
    "dblclick .trash": -> logics.returns.removeReturnDetail(@_id)