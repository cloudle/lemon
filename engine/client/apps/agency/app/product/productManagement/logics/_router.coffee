scope = logics.agencyProductManagement
lemon.addRoute
  template: 'agencyProductManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Agency.agencyProductManagementInit, 'agencyProductManagement')
      Session.set "currentAppInfo",
        name: "sản phẩm"
      @next()
  data: ->
    Apps.setup(scope, Apps.Agency.agencyProductManagementReactive)

    return {
      managedProductList  : scope.managedAgencyProductList
    }
, Apps.Merchant.RouterBase
