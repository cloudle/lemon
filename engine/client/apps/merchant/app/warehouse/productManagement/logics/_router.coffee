scope = logics.productManagement
lemon.addRoute
  template: 'productManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.productManagementInit, 'productManagement')
      Session.set "currentAppInfo",
        name: "sản phẩm"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.productManagementReactive)

    return {
      managedProductList  : scope.managedProductList
    }
, Apps.Merchant.RouterBase
