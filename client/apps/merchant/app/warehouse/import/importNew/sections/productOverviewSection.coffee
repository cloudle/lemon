scope = logics.import
lemon.defineHyper Template.importCurrentProductOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "importCurrentProductShowEditCommand"
  name: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$productName.change()
    ,50 if scope.overviewTemplateInstance
    @name
  firstName: -> Helpers.firstName(@name)

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$productName.autosizeInput({space: 20})
    @ui.$productPrice.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
#      files = event.target.files
#      if files.length > 0
#        AvatarImages.insert files[0], (error, fileObj) ->
#          Schema.customers.update(Session.get('customerManagementCurrentCustomer')._id, {$set: {avatar: fileObj._id}})
#          AvatarImages.findOne(Session.get('customerManagementCurrentCustomer').avatar)?.remove()

    "input .editable": (event, template) ->
      Session.set "importCurrentProductShowEditCommand",
        template.ui.$productName.val() isnt Session.get("importCurrentProduct").name or
        Number(template.ui.$productPrice.inputmask('unmaskedvalue')) isnt (Session.get("importCurrentProduct").price ? '')


    "keyup input.editable": (event, template) ->
      if event.which is 27
        if $(event.currentTarget).attr('name') is 'productName'
          $(event.currentTarget).val(Session.get("importCurrentProduct").name)
          $(event.currentTarget).change()
        else if $(event.currentTarget).attr('name') is 'productPrice'
          $(event.currentTarget).val(Session.get("importCurrentProduct").price)

      Session.set "importCurrentProductShowEditCommand",
        template.ui.$productName.val() isnt Session.get("importCurrentProduct").name or
        Number(template.ui.$productPrice.inputmask('unmaskedvalue')) isnt (Session.get("importCurrentProduct").price ? '')

      scope.editProduct(template) if event.which is 13


    "click .syncProductEdit": (event, template) -> scope.editProduct(template)