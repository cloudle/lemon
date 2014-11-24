resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")
Apps.Merchant.staffManagementInit.push (scope) ->
  Session.set("staffManagementCurrentStaff", Schema.userProfiles.findOne())

  scope.checkAllowCreateStaff = (context) ->
    email = template.ui.$email.val()
    password = template.ui.$password.val()
    confirm = template.ui.$confirm.val()
    fullName = template.ui.$fullName.val()
    if Meteor.users.findOne({'emails.address': email}) then return Session.set('allowCreateStaffAccount', false)
    if email.length > 0 and password.length > 0 and confirm.length > 0 and fullName.length > 0 and password is confirm
      if _.findWhere(Session.get('availableUserProfile'), {fullName: fullName})
        Session.set('allowCreateStaffAccount', false)
      else
        Session.set('allowCreateStaffAccount', true)
    else
      Session.set('allowCreateStaffAccount', false)

  scope.createStaff = (context)->
    $name    = context.ui.$name
    $phone   = context.ui.$phone
    $address = context.ui.$address

    result = Staff.createNew($name.val(), $phone.val(), $address.val())
    if result.error then $name.notify(result.error, {position: "bottom"})
    else Session.set('allowCreateStaffAccount', false)