scope = logics.distributorManagement
lemon.addRoute
  template: 'distributorManagement'
  waitOnDependency: 'distributorManagement'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.distributorManagementInit, 'distributorManagement')
      Session.set "currentAppInfo",
        name: "nhà cung cấp"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.distributorManagementReactive)

    return {
      managedDistributorList : scope.managedDistributorList
      allowCreateDistributor : scope.allowCreateDistributor
    }
, Apps.Merchant.RouterBase
