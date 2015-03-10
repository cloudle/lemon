scope = logics.customerManagement

lemon.defineHyper Template.customerManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "customerManagementShowEditCommand"
  showDeleteCommand: -> Session.get("customerManagementCurrentCustomer")?.allowDelete
  name: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$customerName.change()
    ,50 if scope.overviewTemplateInstance
    @name
  firstName: -> Helpers.firstName(@name)

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

    "input .editable": (event, template) -> scope.checkAllowUpdateOverview(template)
    "keyup input.editable": (event, template) ->
      if Session.get("customerManagementCurrentCustomer")
        scope.editCustomer(template) if event.which is 13

        if event.which is 27
          if $(event.currentTarget).attr('name') is 'customerName'
            $(event.currentTarget).val(Session.get("customerManagementCurrentCustomer").name)
            $(event.currentTarget).change()
          else if $(event.currentTarget).attr('name') is 'customerPhone'
            $(event.currentTarget).val(Session.get("customerManagementCurrentCustomer").phone)
          else if $(event.currentTarget).attr('name') is 'customerAddress'
            $(event.currentTarget).val(Session.get("customerManagementCurrentCustomer").address)

          scope.checkAllowUpdateOverview(template)

    "click .syncCustomerEdit": (event, template) -> scope.editCustomer(template)
    "click .customerDelete": (event, template) ->
      if @allowDelete
        if Schema.customers.remove @_id
          UserSession.set('currentCustomerManagementSelection', Schema.customers.findOne()?._id ? '')
          Meteor.call 'updateMetroSummaryBy', 'deleteCustomer', @

