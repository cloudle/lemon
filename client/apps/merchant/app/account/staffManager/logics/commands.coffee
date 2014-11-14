
Apps.Merchant.staffManagerInit.push (scope) ->
  scope.resetForm = (context) ->
    $(item).val('') for item in context.findAll("[name]")
    Session.set('currentRoleSelection', [])

  scope.createStaffAccount = (template) ->
    dateOfBirth = template.datePicker.$dateOfBirth.data('datepicker').dates[0]
    startWorkingDate = template.datePicker.$startWorkingDate.data('datepicker').dates[0]
    email = template.ui.$email.val()
    password = template.ui.$password.val()
    fullName = template.ui.$fullName.val()
    unless Meteor.users.findOne({'emails.address': email}) || Schema.userProfiles.findOne({fullName: fullName})
      roles = []
      if Session.get('currentRoleSelection')?.length > 0
        roles.push role.name for role in Session.get('currentRoleSelection')
      newProfile =
        parentMerchant    : Session.get("myProfile").parentMerchant
        currentMerchant   : Session.get("createStaffBranchSelection")._id
        currentWarehouse  : Session.get("createStaffWarehouseSelection")._id
        fullName          : fullName
        systemVersion     : Schema.systems.findOne().version

      newProfile.roles = roles if roles.length > 0
      newProfile.dateOfBirth = dateOfBirth if dateOfBirth
      newProfile.startWorkingDate = startWorkingDate if startWorkingDate
      newProfile.gender = Session.get("createStaffGenderSelection") if fullName

      Meteor.call "createMerchantAccount", email, password, newProfile
      #      Meteor.call "createMerchantAccount",
      #        email: template.ui.$email.val()
      #        password: template.ui.$password.val()

      newMemberName = fullName ? email
#      Notification.newMemberJoined(newMemberName, Session.get("merchantPackages").companyName)
      scope.resetForm(template)