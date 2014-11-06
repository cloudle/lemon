logics.roleManager.createNewRole = (event, template) ->
  newRole = Schema.roles.insert
    group: 'merchant'
    name: template.ui.$newGroupName.val()

  template.ui.$newGroupName.val('')
  logics.roleManager.checkAllowCreate(template)
  Session.set('currentRoleSelection', Schema.roles.findOne(newRole))

logics.roleManager.saveRoleOptions = (event, template) ->
  return if !Session.get('currentRoleSelection')
  newPermissions = []
  for permission, switchery of template.switch
    newPermissions.push permission if switchery.isChecked()

  Schema.roles.update(Session.get('currentRoleSelection')._id, {$set: {permissions: newPermissions}})
#  Notification.permissionChanged(Session.get('currentRoleSelection'))r.createNewRole = (event, template) ->
  newRole = Schema.roles.insert
    group: 'merchant'
    name: template.ui.$newGroupName.val()

  template.ui.$newGroupName.val('')
  logics.roleManager.checkAllowCreate(template)
  Session.set('currentRoleSelection', Schema.roles.findOne(newRole))

logics.roleManager.saveRoleOptions = (event, template) ->
  return if !Session.get('currentRoleSelection')
  newPermissions = []
  for permission, switchery of template.switch
    newPermissions.push permission if switchery.isChecked()

  Schema.roles.update(Session.get('currentRoleSelection')._id, {$set: {permissions: newPermissions}})
#  Notification.permissionChanged(Session.get('currentRoleSelection'))