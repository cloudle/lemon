Apps.Merchant.roleManangementInit.push (scope) ->
  scope.createNewRole = (event, template) ->
    if event.which is 13 and Session.get("roleManagementCreationMode") and Session.get("roleManagementSearchFilter")?.trim()?.length > 1
      newRole =
        group : 'merchant'
        name  : Session.get("roleManagementSearchFilter")
        parent: Session.get("myProfile").parentMerchant
        permissions: []

      existedRole = _.findWhere(scope.managedBuitInRoles, {name: newRole.name})
      existedRole = _.findWhere(scope.managedCustomRoles, {name: newRole.name}) if existedRole is undefined
      if existedRole is undefined
        if roleId = Schema.roles.insert newRole
          template.ui.$searchFilter.val('')
          Session.set("roleManagementCreationMode", false)
          Session.set("roleManagementSearchFilter")
          Session.set('currentRoleSelection', Schema.roles.findOne(roleId))

  scope.deleteNewRole = (roleId) ->
    if role = Schema.roles.findOne({_id: roleId, parent: Session.get("myProfile")?.parentMerchant})
      Schema.roles.remove role._id if role.allowDelete is true

  scope.saveRoleOptions = (event, template) ->
    currentRole = Session.get('currentRoleSelection')
    myProfile = Session.get('myProfile')
    return if !currentRole or !currentRole.parent or !myProfile
    newPermissions = []
    for permission, switchery of template.switch
      newPermissions.push permission if switchery.isChecked()

    Schema.roles.update(currentRole._id, {$set: {permissions: newPermissions}})
    Session.set('currentRoleSelection', Schema.roles.findOne currentRole._id)
    Meteor.call('permissionChanged', myProfile, currentRole)
