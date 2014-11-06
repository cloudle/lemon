logics.roleManager.checkAllowCreate = (context) ->
  groupName = context.ui.$newGroupName.val()
  if !groupName or groupName.length < 1
    Session.set('allowCreateNewRole', false)
    return

  existedRole = Schema.roles.findOne {name: groupName}
  Session.set('allowCreateNewRole', existedRole is undefined)
