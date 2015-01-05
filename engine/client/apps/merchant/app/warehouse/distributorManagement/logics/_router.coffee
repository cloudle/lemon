scope = logics.distributorManagement
lemon.addRoute
  template: 'distributorManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.distributorManagementInit, 'distributorManagement')
      Session.set "currentAppInfo",
        name: "nhà cung cấp"
        navigationPartial:
          template: "distributorManagementNavigationPartial"
          data: {}
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.distributorManagementReactive)

    return {
      managedDistributorList : scope.managedDistributorList
      managedReturnProductList : scope.managedReturnProductList
#      allowCreateDistributor : scope.allowCreateDistributor
    }
, Apps.Merchant.RouterBase
