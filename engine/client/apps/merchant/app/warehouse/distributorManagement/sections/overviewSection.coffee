scope = logics.distributorManagement

lemon.defineHyper Template.distributorManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "distributorManagementShowEditCommand"
  showDeleteCommand: -> Session.get("distributorManagementCurrentDistributor")?.allowDelete
  name: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$distributorName.change()
    , 50 if scope.overviewTemplateInstance
    @name

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$distributorName.autosizeInput({space: 10})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.distributors.update(Session.get('distributorManagementCurrentDistributor')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('distributorManagementCurrentDistributor').avatar)?.remove()

    "input .editable": (event, template) -> scope.checkAllowUpdateDistributorOverview(template)
    "keyup input.editable": (event, template) ->
      scope.editDistributor(template) if event.which is 13

      if event.which is 27
        if $(event.currentTarget).attr('name') is 'distributorName'
          $(event.currentTarget).val(Session.get("distributorManagementCurrentDistributor").name)
          $(event.currentTarget).change()
        else if $(event.currentTarget).attr('name') is 'distributorPhone'
          $(event.currentTarget).val(Session.get("distributorManagementCurrentDistributor").phone)
        else if $(event.currentTarget).attr('name') is 'distributorAddress'
          $(event.currentTarget).val(Session.get("distributorManagementCurrentDistributor").location?.address)

        scope.checkAllowUpdateDistributorOverview(template)

    "click .syncDistributorEdit": (event, template) -> scope.editDistributor(template)
    "click .distributorDelete": (event, template) -> scope.deleteDistributor(@)