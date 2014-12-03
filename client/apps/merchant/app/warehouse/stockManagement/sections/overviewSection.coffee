scope = logics.stockManagement

lemon.defineHyper Template.stockManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "stockManagementShowEditCommand"
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
          Schema.products.update(Session.get('stockManagementCurrentProduct')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('stockManagementCurrentProduct').avatar)?.remove()
    "input .editable": (event, template) ->
      Session.set "stockManagementShowEditCommand",
        template.ui.$productName.val() isnt Session.get("stockManagementCurrentProduct").name or
        template.ui.$productPhone.val() isnt (Session.get("stockManagementCurrentProduct").phone ? '') or
        template.ui.$productAddress.val() isnt (Session.get("stockManagementCurrentProduct").address ? '')
    "keyup input.editable": (event, template) ->
      scope.editProduct(template) if event.which is 13

      if event.which is 27
        if $(event.currentTarget).attr('name') is 'productName'
          $(event.currentTarget).val(Session.get("stockManagementCurrentProduct").name)
          $(event.currentTarget).change()
        else if $(event.currentTarget).attr('name') is 'productPhone'
          $(event.currentTarget).val(Session.get("stockManagementCurrentProduct").phone)
        else if $(event.currentTarget).attr('name') is 'productAddress'
          $(event.currentTarget).val(Session.get("stockManagementCurrentProduct").address)

    "click .syncProductEdit": (event, template) -> scope.editProduct(template)