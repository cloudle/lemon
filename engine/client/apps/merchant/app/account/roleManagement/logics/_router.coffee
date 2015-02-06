scope = logics.roleManagement

getPermissionGroups = ->
  results = []
  for name, group of Apps.Merchant.PermissionGroups
    for permission, index in group.children
      group.children[index] = Apps.Merchant.Permissions[permission] ? permission
    results.push group

  console.log results
  results

roleManagerRoute =
  template: 'roleManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.roleMamangementInit, 'roleManagement')
      Session.set "currentAppInfo",
        name: "phân quyền"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.roleMamangementReactive)
    return {
      permissionGroups: getPermissionGroups()
      scope: scope
    }

lemon.addRoute [roleManagerRoute], Apps.Merchant.RouterBase