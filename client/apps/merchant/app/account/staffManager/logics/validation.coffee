Apps.Merchant.staffManagerInit.push (scope) ->
  scope.checkAllowCreate = (template) ->
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