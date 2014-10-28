getPermissionArray = -> obj for permission, obj of Apps.Merchant.Permissions
roleManagerRoute =
  template: 'roleManager',
  waitOn: -> lemon.dependencies.resolve('roleManager')
  data: -> {
    permissions: getPermissionArray()
    roleSelectOptions: logics.roleManager.roleSelectOptions
  }
_.extend(roleManagerRoute, Merchant.merchantRouteBase)

lemon.addRoute [roleManagerRoute]