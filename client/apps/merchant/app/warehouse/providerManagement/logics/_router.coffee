scope = logics.providerManagement
lemon.addRoute
  template: 'providerManagement'
  waitOnDependency: 'providerManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.providerManagementInit, 'providerManagement')
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.providerManagementReactive)

    return {
      managedProviderList: scope.managedProviderList
    }
, Apps.Merchant.RouterBase
