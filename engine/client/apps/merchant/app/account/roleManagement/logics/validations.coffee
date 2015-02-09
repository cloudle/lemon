#Apps.Merchant.roleManangementInit.push (scope) ->
#  scope.checkAllowCreate = (context) ->
#    groupName = context.ui.$newGroupName.val()
#    if !groupName or groupName.length < 1
#      Session.set('allowCreateNewRole', false)
#      return
#
#    existedRole = Schema.roles.findOne {name: groupName}
#    Session.set('allowCreateNewRole', existedRole is undefined)

#formatRoleSelect = (item) -> "#{item.description ? item.name}" if item
#syncSwitchState = (switchery, turnOn) ->
#  changeSateHook = switchery.isChecked() isnt turnOn
#  switchery.element.click() if changeSateHook
#
#logics.roleManager.roleSelectOptions =
#  query: (query) -> query.callback
#    results: Schema.roles.find({}, {sort: {'version.updateAt': -1}}).fetch()
#  initSelection: (element, callback) -> callback Session.get('currentRoleSelection')
#  changeAction: (e) ->
#    Session.set('currentRoleSelection', e.added)
#    for permissionName, switchery of logics.roleManager.rolesTemplateContext.switch
#      hasPermission = _.contains(e.added.permissions, permissionName)
#      syncSwitchState(switchery, hasPermission)
#
#  reactiveValueGetter: -> Session.get('currentRoleSelection')
#  formatSelection: formatRoleSelect
#  formatResult: formatRoleSelect