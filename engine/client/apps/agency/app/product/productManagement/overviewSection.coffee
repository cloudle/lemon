scope = logics.agencyProductManagement

lemon.defineHyper Template.agencyProductManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  unitEditingMode: -> Session.get("agencyProductManagementUnitEditingRow")?._id is @_id
  unitEditingData: -> Session.get("agencyProductManagementUnitEditingRow")

  productCode: -> @productCode ? Schema.buildInProductUnits.findOne(@buildInProductUnit)?.productCode
  unit: -> @unit ? Schema.buildInProductUnits.findOne(@buildInProductUnit)?.unit
  conversionQuality: -> @conversionQuality ? Schema.buildInProductUnits.findOne(@buildInProductUnit)?.conversionQuality

  basicDetailModeEnabled: -> Session.get('agencyProductManagementCurrentProduct')?.basicDetailModeEnabled
  hasUnit: -> Schema.productUnits.findOne({product: @_id})
  productUnitList: -> Schema.productUnits.find({product: @_id})

  showEditCommand: -> Session.get "agencyProductManagementShowEditCommand"
  showDeleteCommand: -> Session.get('agencyProductManagementCurrentProduct')?.allowDelete
  showCreateUnitMode: ->
    if Session.get('agencyProductManagementCurrentProduct')?.buildInProduct then false
    else if Session.get('agencyProductManagementCurrentProduct')?.basicUnit then true else false
  showDeleteUnit: -> !@buildInProductUnit and @allowDelete


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

  importPrice: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$importPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11, rightAlign:false}
    , 50 if scope.overviewTemplateInstance
    @importPrice

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$productName.autosizeInput({space: 10})
    @ui.$productPrice.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11, rightAlign:false})
    @ui.$importPrice.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11, rightAlign:false})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.products.update(Session.get('agencyProductManagementCurrentProduct')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('agencyProductManagementCurrentProduct').avatar)?.remove()

    "click .edit-unit": -> Session.set("agencyProductManagementUnitEditingRowId", @_id)
    "click .createUnit": -> scope.createProductUnit(@, Session.get('myProfile'))
    "click .delete-unit": -> scope.deleteProductUnit(@)


    "click .syncProductEdit": (event, template) -> scope.editProduct(template)
    "click .productDelete": -> scope.deleteProduct(@)
    "click .add-basicDetail": ->
      product = Session.get('agencyProductManagementCurrentProduct')
      branchProductSummary = Session.get('agencyProductManagementBranchProductSummary')
      scope.addBasicProductDetail(@, product, branchProductSummary, Session.get('myProfile'))

    "input .editable": (event, template) -> scope.checkValidEditProduct(template)
    "keyup input.editable": (event, template) -> scope.checkValidAndUpdateProduct(event, template)

