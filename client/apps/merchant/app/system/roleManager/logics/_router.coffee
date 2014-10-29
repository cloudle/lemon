getPermissionArray = -> obj for permission, obj of Apps.Merchant.Permissions
roleManagerRoute =
  template: 'roleManager',
  waitOn: -> lemon.dependencies.resolve('roleManager', Apps.MerchantSubscriber)
  data: -> {
    permissions: getPermissionArray()
    roleSelectOptions: logics.roleManager.roleSelectOptions
  }
_.extend(roleManagerRoute, Apps.Merchant.RouterBase)

lemon.addRoute [roleManagerRoute]