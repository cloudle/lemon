scope = logics.productManagement
lemon.addRoute
  template: 'productManagement'
  waitOnDependency: 'productManagement'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.productManagementInit, 'productManagement')
      Session.set "currentAppInfo",
        name: "sản phẩm"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.productManagementReactive)

    return {
      managedSalesProductList  : scope.managedSalesProductList
    }
, Apps.Merchant.RouterBase
