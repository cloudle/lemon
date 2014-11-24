scope = logics.providerManagement
lemon.addRoute
  template: 'providerManagement'
  waitOnDependency: 'providerManagement'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.providerManagementInit, 'providerManagement')
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.providerManagementReactive)

    return {
      managedProviderList : scope.managedProviderList
      allowCreateProvider : scope.allowCreateProvider
    }
, Apps.Merchant.RouterBase
