scope = logics.roleManagement

getPermissionGroups = ->
  results = []
  for name, group of Apps.Merchant.TempPermissionGroups
    for permission, index in group.children
      group.children[index] = Apps.Merchant.TempPermissions[permission] ? permission
    results.push group

  results

roleManagerRoute =
  template: 'roleManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.roleManangementInit, 'roleManagement')
      Session.set "currentAppInfo",
        name: "phân quyền"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.roleManangementReactive)
    return {
      permissionGroups: getPermissionGroups()
      scope: scope
    }

lemon.addRoute [roleManagerRoute], Apps.Merchant.RouterBase