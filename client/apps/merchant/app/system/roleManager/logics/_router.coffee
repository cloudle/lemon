getPermissionArray = -> obj for permission, obj of Apps.Merchant.Permissions
roleManagerRoute =
  template: 'roleManager',
  waitOn: -> lemon.dependencies.resolve('roleManager', Apps.MerchantSubscriber)
  data: -> {
    permissions: getPermissionArray()
    roleSelectOptions: logics.roleManager.roleSelectOptions
  }

lemon.addRoute [roleManagerRoute], Apps.Merchant.RouterBase