scope = logics.productManagement
lemon.addRoute
  template: 'productManagement'
  waitOnDependency: 'productManagement'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.productManagementInit, 'productManagement')
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.productManagementReactive)

    return {
      managedProductList  : scope.managedProductList
    }
, Apps.Merchant.RouterBase
