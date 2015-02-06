logics.roleManagement = {}
logics.roleManagement.rolesTemplateContext = undefined
Apps.Merchant.roleMamangementInit = []
Apps.Merchant.roleMamangementReactive = []


syncSwitchState = (switchery, turnOn) ->
  changeSateHook = switchery.isChecked() isnt turnOn
  switchery.element.click() if changeSateHook

Apps.Merchant.roleMamangementInit.push (scope) ->
  scope.buitInRoles = Schema.roles.find $and: [{group: 'merchant'}, {parent: {$exists: false}}]
  scope.customRoles = Schema.roles.find $and: [{group: 'merchant'}, {parent: Session.get('myProfile')?.parentMerchant}]

Apps.Merchant.roleMamangementReactive.push (scope) ->
  Session.setDefault('currentRoleSelection', Schema.roles.findOne())

  if Session.get('currentRoleSelection')
    for permissionName, switchery of scope.templateContext?.switch
      hasPermission = _.contains(Session.get('currentRoleSelection').permissions, permissionName)
      syncSwitchState(switchery, hasPermission)