getPermissionGroups = ->
  results = []
  for name, group of Apps.Merchant.PermissionGroups
    for permission, index in group.children
      group.children[index] = Apps.Merchant.Permissions[permission] ? permission
    results.push group

  console.log results
  results

roleManagerRoute =
  template: 'roleManager',
  waitOn: -> lemon.dependencies.resolve('roleManager', Apps.MerchantSubscriber)
  data: -> {
    permissionGroups: getPermissionGroups()
    roleSelectOptions: logics.roleManager.roleSelectOptions
  }

lemon.addRoute [roleManagerRoute], Apps.Merchant.RouterBase