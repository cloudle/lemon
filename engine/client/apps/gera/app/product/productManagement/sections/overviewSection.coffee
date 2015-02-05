scope = logics.geraProductManagement

lemon.defineHyper Template.geraProductManagementOverviewSection,
  unitEditingMode: -> Session.get("geraProductManagementUnitEditingRow")?._id is @_id
  unitEditingData: -> Session.get("geraProductManagementUnitEditingRow")

  showEditCommand   : -> Session.get "geraProductManagementShowEditCommand"
  showSubmitCommand : -> if !Session.get("geraProductManagementShowEditCommand") and @status is "copy" then true else false
  showDeleteCommand : -> if @status is "brandNew" || @status is "copy" then true else false
  showCreateUnitMode: -> if @basicUnit then true else false

  avatarUrl   : -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  hasUnit     : -> Schema.buildInProductUnits.findOne({buildInProduct: @_id})
  buildInProductUnitList: -> Schema.buildInProductUnits.find({buildInProduct: @_id})

  name: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$productName.change()
    , 50 if scope.overviewTemplateInstance
    @name
  description: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$description.change()
    , 50 if scope.overviewTemplateInstance
    @description
#  price: ->
#    Meteor.setTimeout ->
#      scope.overviewTemplateInstance.ui.$productPrice.inputmask "numeric",
#        {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11, rightAlign:false}
#    , 50 if scope.overviewTemplateInstance
#    @price
#  importPrice: ->
#    Meteor.setTimeout ->
#      scope.overviewTemplateInstance.ui.$productImportPrice.inputmask "numeric",
#        {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11, rightAlign:false}
#    , 50 if scope.overviewTemplateInstance
#    @importPrice

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$productName.autosizeInput({space: 10})
    @ui.$description.autosizeInput({space: 10})
#    @ui.$productPrice.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11, rightAlign:false})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.buildInProducts.update(Session.get('geraProductManagementCurrentProduct')._id, {$set: {image: fileObj._id}})
          AvatarImages.findOne(Session.get('geraProductManagementCurrentProduct').image)?.remove()

    "click .syncProductEdit": (event, template)-> scope.updateGeraProduct(template, @)
    "click .submitProduct": (event, template)-> scope.submitGeraProduct(@)
    "click .productDelete": (event, template) -> scope.deleteGeraProduct(@)
    "keyup input.editable": (event, template) -> scope.checkAndUpdateGeraProduct(event, template, @)

    "click .createUnit": (event, template)-> scope.createGeraProductUnit(@)
    "click .edit-unit": (event, template)->  Session.set("geraProductManagementUnitEditingRowId", @_id)
    "click .delete-unit": (event, template)-> Schema.buildInProductUnits.remove(@_id) if @status is 'New'

#    "input .editable": (event, template) ->
#      Session.set "geraProductManagementShowEditCommand",
#        template.ui.$productName.val() isnt Session.get("geraProductManagementCurrentProduct").name or
#        template.ui.$description.val() isnt Session.get("geraProductManagementCurrentProduct").description or
#        template.ui.$productCode.val() isnt Session.get("geraProductManagementCurrentProduct").productCode

