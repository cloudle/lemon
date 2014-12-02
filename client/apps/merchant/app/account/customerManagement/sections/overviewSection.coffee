scope = logics.customerManagement

lemon.defineHyper Template.customerManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "customerManagementShowEditCommand"
  name: ->
    Meteor.setTimeout(scope.overviewTemplateInstance?.ui.$customerName.change(), 50)
    @name

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$customerName.autosizeInput({space: 10})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.customers.update(Session.get('customerManagementCurrentCustomer')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('customerManagementCurrentCustomer').avatar)?.remove()
    "input .editable": (event, template) ->
      Session.set "customerManagementShowEditCommand",
        template.ui.$customerName.val() isnt Session.get("customerManagementCurrentCustomer").name
    "click .syncCustomerEdit": (event, template) -> scope.editCustomer(template)
    "keypress [name='customerName']": (event, template) -> scope.editCustomer(template) if event.which is 13