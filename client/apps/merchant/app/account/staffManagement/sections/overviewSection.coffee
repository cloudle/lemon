scope = logics.staffManagement

lemon.defineHyper Template.staffManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "staffManagementShowEditCommand"
  showDeleteCommand: -> Session.get("staffManagementCurrentStaff")?.allowDelete
  name: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$staffName.change()
    ,50 if scope.overviewTemplateInstance
    @name
  firstName: -> Helpers.firstName(@name)

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$staffName.autosizeInput({space: 10})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.staffs.update(Session.get('staffManagementCurrentStaff')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('staffManagementCurrentStaff').avatar)?.remove()

    "input .editable": (event, template) -> scope.checkAllowUpdateOverview(template)
    "keyup input.editable": (event, template) ->
      if Session.get("staffManagementCurrentStaff")
        scope.editStaff(template) if event.which is 13

        if event.which is 27
          if $(event.currentTarget).attr('name') is 'staffName'
            $(event.currentTarget).val(Session.get("staffManagementCurrentStaff").name)
            $(event.currentTarget).change()
          else if $(event.currentTarget).attr('name') is 'staffPhone'
            $(event.currentTarget).val(Session.get("staffManagementCurrentStaff").phone)
          else if $(event.currentTarget).attr('name') is 'staffAddress'
            $(event.currentTarget).val(Session.get("staffManagementCurrentStaff").address)

          scope.checkAllowUpdateOverview(template)

    "click .syncStaffEdit": (event, template) -> scope.editStaff(template)
    "click .staffDelete": (event, template) ->
      if @allowDelete
        Schema.staffs.remove @_id
        UserSession.set('currentStaffManagementSelection', Schema.staffs.findOne()?._id ? '')

