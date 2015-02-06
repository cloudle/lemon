Apps.Merchant.roleMamangementInit.push (scope) ->
  scope.createNewRole = (event, template) ->
    newRole = Schema.roles.insert
      group: 'merchant'
      name: template.ui.$newGroupName.val()
      parent: Session.get("myProfile").parentMerchant
      permissions: []

    template.ui.$newGroupName.val('')
    logics.roleManager.checkAllowCreate(template)
    Session.set('currentRoleSelection', Schema.roles.findOne(newRole))

  scope.saveRoleOptions = (event, template) ->
    return if !Session.get('currentRoleSelection')
    newPermissions = []
    for permission, switchery of template.switch
      newPermissions.push permission if switchery.isChecked()

    Schema.roles.update(Session.get('currentRoleSelection')._id, {$set: {permissions: newPermissions}})
    Meteor.call('permissionChanged', Session.get('myProfile'), Session.get('currentRoleSelection'))
