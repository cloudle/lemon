scope = logics.staffManagement

lemon.defineHyper Template.staffManagementOverviewSection,
  firstName: -> Helpers.firstName(@currentStaff?.fullName)
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "staffManagementShowEditCommand"
  showDeleteCommand: -> Session.get("staffManagementCurrentStaff")?.allowDelete

  userName: -> Meteor.users.findOne(@currentStaff?.user)?.emails[0].address ? 'chưa tạo tài khoản đăng nhập.'
  branchName: -> Schema.merchants.findOne(@currentStaff?.currentMerchant)?.name ? 'chưa cập nhât'
  genderName: -> if @currentStaff?.gender then 'Nam' else 'Nữ'

  showCreateEmail: -> if Meteor.users.findOne(@currentStaff?.user) then false else true

  fullName: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$staffName.change()
    ,50 if scope.overviewTemplateInstance
    @currentStaff?.fullName


  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$staffName.autosizeInput({space: 10})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.userProfiles.update(Session.get('staffManagementCurrentStaff')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('staffManagementCurrentStaff').avatar)?.remove()

    "input .editable": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        Session.set "staffManagementShowEditCommand", template.ui.$staffName.val() isnt staff.fullName

    "keyup input.editable": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        Session.set "staffManagementShowEditCommand", template.ui.$staffName.val() isnt staff.fullName
        if event.which is 27
          if $(event.currentTarget).attr('name') is 'staffName'
            $(event.currentTarget).val(staff.fullName); $(event.currentTarget).change()

        scope.editStaff(template) if event.which is 13

    "blur .email": (event, template)->
      $email = $(template.find(".email"))
      if $email.val().length > 0
        unless Helpers.isEmail($email.val()) then $email.notify('Tài khoản phải là email')

    "click .updateEmailOfStaff": (event, template) -> scope.updateEmailOfStaff(template)
    "click .syncStaffEdit": (event, template) -> scope.editStaff(template)
    "click .staffDelete": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        if staff.allowDelete and staff._id isnt Session.get('myProfile')._id
          Schema.userProfiles.remove staff._id
          UserSession.set('currentStaffManagementSelection', Schema.userProfiles.findOne()?._id ? '')

