scope = logics.productManagement

lemon.defineHyper Template.productManagementOverviewSection,
  unitEditingMode: -> Session.get("productManagementUnitEditingRow")?._id is @_id
  unitEditingData: -> Session.get("productManagementUnitEditingRow")
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "productManagementShowEditCommand"
  showDeleteCommand: -> Session.get('productManagementCurrentProduct')?.allowDelete
  showCreateUnitMode: -> if Session.get('productManagementCurrentProduct')?.basicUnit then true else false
  basicDetailModeEnabled: -> Session.get('productManagementCurrentProduct')?.basicDetailModeEnabled
  hasUnit: -> Schema.productUnits.findOne({product: @_id})
  averagePrice: ->
    if product = Session.get('productManagementCurrentProduct')
      productDetails = Schema.productDetails.find({product: product._id}).fetch()
      totalQuality = 0
      totalPrice = 0
      for productDetail in productDetails
        totalQuality += productDetail.importQuality
        totalPrice += productDetail.importQuality * productDetail.importPrice
      totalPrice/totalQuality
  productUnits: -> Schema.productUnits.find({product: @_id})
  name: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$productName.change()
    , 50 if scope.overviewTemplateInstance
    @name

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$productName.autosizeInput({space: 10})
    @ui.$productPrice.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.products.update(Session.get('productManagementCurrentProduct')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('productManagementCurrentProduct').avatar)?.remove()

    #TODO: Chinh lai truong hop bi trung randomBarcode()
    "click .createUnit": ->
      if @basicUnit
        newId = Schema.productUnits.insert {
          product: @_id
          productCode: Helpers.randomBarcode()
        }
        Session.set("productManagementUnitEditingRowId", newId)

    "click .edit-unit": -> Session.set("productManagementUnitEditingRowId", @_id)

    "click .add-basicDetail": ->
      if product = Session.get('productManagementCurrentProduct')
        if productUnit = Schema.productUnits.findOne({_id: @_id, product: product._id})
          productDetailOption =
            merchant          : product.merchant
            warehouse         : product.warehouse
            product           : product._id
            unit              : productUnit._id
            unitQuality       : 1
            unitPrice         : productUnit.price
            conversionQuality : productUnit.conversionQuality
            importQuality     : productUnit.conversionQuality
            availableQuality  : productUnit.conversionQuality
            inStockQuality    : productUnit.conversionQuality
            importPrice       : productUnit.price
#          productDetailOption.expire
        Schema.productDetails.insert productDetailOption
        Schema.productUnits.update @_id, $set:{allowDelete: false}
        Schema.products.update product._id, $set:{allowDelete: false}, $inc:{
          totalQuality    : productUnit.conversionQuality
          availableQuality: productUnit.conversionQuality
          inStockQuality  :productUnit.conversionQuality
        }
        Session.set("productManagementUnitEditingRow")
        Session.set("productManagementUnitEditingRowId")

    "click .delete-unit": -> Schema.productUnits.remove(@_id) if @allowDelete


    "input .editable": (event, template) ->
      Session.set "productManagementShowEditCommand",
        template.ui.$productName.val() isnt Session.get("productManagementCurrentProduct").name or
        template.ui.$productPrice.inputmask('unmaskedvalue') isnt (Session.get("productManagementCurrentProduct").price ? '')

    "keyup input.editable": (event, template) ->
      if event.which is 27
        if $(event.currentTarget).attr('name') is 'productName'
          $(event.currentTarget).val(Session.get("productManagementCurrentProduct").name)
          $(event.currentTarget).change()
        else if $(event.currentTarget).attr('name') is 'productPrice'
          $(event.currentTarget).val(Session.get("productManagementCurrentProduct").price)

      Session.set "productManagementShowEditCommand",
        template.ui.$productName.val() isnt Session.get("productManagementCurrentProduct").name or
        Number(template.ui.$productPrice.inputmask('unmaskedvalue')) isnt (Session.get("productManagementCurrentProduct").price ? '')

      scope.editProduct(template) if event.which is 13

    "click .syncProductEdit": (event, template) -> scope.editProduct(template)
    "click .productDelete": (event, template) ->
      if @allowDelete
        Schema.products.remove @_id
        UserSession.set('currentProductManagementSelection', Schema.products.findOne()?._id ? '')