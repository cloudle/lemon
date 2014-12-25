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
#  averagePrice: ->
#    if product = Session.get('productManagementCurrentProduct')
#      productDetails = Schema.productDetails.find({product: product._id}).fetch()
#      totalQuality = 0
#      totalPrice = 0
#      for productDetail in productDetails
#        totalQuality += productDetail.importQuality
#        totalPrice += productDetail.importQuality * productDetail.importPrice
#      totalPrice/totalQuality
  productUnits: -> Schema.productUnits.find({product: @_id})

  name: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$productName.change()
    , 50 if scope.overviewTemplateInstance
    @name
  price: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$productPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11, rightAlign:false}
    , 50 if scope.overviewTemplateInstance
    @price

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$productName.autosizeInput({space: 10})
    @ui.$productPrice.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11, rightAlign:false})

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
        if @_id is product._id
          detailOption =
            merchant          : product.merchant
            warehouse         : product.warehouse
            product           : product._id
            unitPrice         : product.importPrice ? 0
            importPrice       : product.importPrice ? 0
            unitQuality       : 1
            conversionQuality : 1
            importQuality     : 1
            availableQuality  : 1
            inStockQuality    : 1
        else
          if productUnit = Schema.productUnits.findOne({_id: @_id, product: product._id})
            detailOption =
              merchant          : product.merchant
              warehouse         : product.warehouse
              product           : product._id
              unitPrice         : productUnit.importPrice
              importPrice       : productUnit.importPrice
              unitQuality       : 1
              unit              : productUnit._id
              conversionQuality : productUnit.conversionQuality
              importQuality     : productUnit.conversionQuality
              availableQuality  : productUnit.conversionQuality
              inStockQuality    : productUnit.conversionQuality

        if detailOption
          productDetailId = Schema.productDetails.insert detailOption
          if Schema.productDetails.findOne(productDetailId)
            Schema.productUnits.update detailOption.unit, $set:{allowDelete: false} if detailOption.unit
            Schema.products.update product._id, $set:{allowDelete: false}, $inc:{
              totalQuality    : detailOption.importQuality
              availableQuality: detailOption.importQuality
              inStockQuality  : detailOption.importQuality
            }
            metroSummary = Schema.metroSummaries.findOne({merchant: Session.get('myProfile').currentMerchant})
            Schema.metroSummaries.update metroSummary._id, $inc:{
              stockProductCount: detailOption.importQuality
              availableProductCount: detailOption.importQuality
            }

    "click .delete-unit": -> Schema.productUnits.remove(@_id) if @allowDelete

    "input .editable": (event, template) ->
      Session.set "productManagementShowEditCommand",
        template.ui.$productName.val() isnt Session.get("productManagementCurrentProduct").name or
        template.ui.$productPrice.inputmask('unmaskedvalue') isnt (Session.get("productManagementCurrentProduct").price ? '') or
        template.ui.$productCode.val() isnt Session.get("productManagementCurrentProduct").productCode

    "keyup input.editable": (event, template) ->
      if event.which is 27
        if $(event.currentTarget).attr('name') is 'productName'
          $(event.currentTarget).val(Session.get("productManagementCurrentProduct").name)
          $(event.currentTarget).change()
        else if $(event.currentTarget).attr('name') is 'productPrice'
          $(event.currentTarget).val(Session.get("productManagementCurrentProduct").price)
        else if $(event.currentTarget).attr('name') is 'productCode'
          $(event.currentTarget).val(Session.get("productManagementCurrentProduct").productCode)
      else if event.which is 13
        scope.editProduct(template)
#      else
#        Session.set "productManagementShowEditCommand",
#          template.ui.$productName.val() isnt Session.get("productManagementCurrentProduct").name or
#          Number(template.ui.$productPrice.inputmask('unmaskedvalue')) isnt (Session.get("productManagementCurrentProduct").price ? '') or
#          template.ui.$productCode.val() isnt Session.get("productManagementCurrentProduct").productCode

    "click .syncProductEdit": (event, template) -> scope.editProduct(template)
    "click .productDelete": (event, template) ->
      if @allowDelete
        Schema.products.remove @_id
        UserSession.set('currentProductManagementSelection', Schema.products.findOne()?._id ? '')
        MetroSummary.updateMetroSummaryBy(['product'])