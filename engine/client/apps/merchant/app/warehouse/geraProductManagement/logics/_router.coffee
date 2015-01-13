scope = logics.geraProductManagement
lemon.addRoute
  template: 'geraProductManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.geraProductManagementInit, 'geraProductManagement')
      Session.set "currentAppInfo",
        name: "sản phẩm gera"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.geraProductManagementReactive)

    return {
      managedProductList  : scope.managedProductList
    }
, Apps.Merchant.RouterBase
