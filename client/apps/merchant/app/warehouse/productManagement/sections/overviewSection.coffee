scope = logics.productManagement

lemon.defineHyper Template.productManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "productManagementShowEditCommand"
  averagePrice: ->
    if product = Session.get('productManagementCurrentProduct')
      productDetails = Schema.productDetails.find({product: product._id}).fetch()
      totalQuality = 0
      totalPrice = 0
      for productDetail in productDetails
        totalQuality += productDetail.importQuality
        totalPrice += productDetail.importQuality * productDetail.importPrice
      totalPrice/totalQuality

  name: ->
    Meteor.setTimeout(scope.overviewTemplateInstance.ui.$productName.change(), 50) if scope.overviewTemplateInstance
    @name

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$productName.autosizeInput({space: 10})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.products.update(Session.get('productManagementCurrentProduct')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('productManagementCurrentProduct').avatar)?.remove()

    "input .editable": (event, template) ->
      Session.set "productManagementShowEditCommand",
        template.ui.$productName.val() isnt Session.get("productManagementCurrentProduct").name or
        Number(template.ui.$productPrice.val()) isnt (Session.get("productManagementCurrentProduct").price ? '')

    "keyup input.editable": (event, template) ->
      scope.editProduct(template) if event.which is 13

      if event.which is 27
        if $(event.currentTarget).attr('name') is 'productName'
          $(event.currentTarget).val(Session.get("productManagementCurrentProduct").name)
          $(event.currentTarget).change()
        else if $(event.currentTarget).attr('name') is 'productPrice'
          $(event.currentTarget).val(Session.get("productManagementCurrentProduct").price)

      Session.set "productManagementShowEditCommand",
        template.ui.$productName.val() isnt Session.get("productManagementCurrentProduct").name or
        Number(template.ui.$productPrice.val()) isnt (Session.get("productManagementCurrentProduct").price ? '')

    "click .syncProductEdit": (event, template) -> scope.editProduct(template)