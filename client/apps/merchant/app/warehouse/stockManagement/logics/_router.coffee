scope = logics.stockManagement
lemon.addRoute
  template: 'stockManagement'
  waitOnDependency: 'stockManagement'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.stockManagementInit, 'stockManagement')
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.stockManagementReactive)

    return {
      managedProductList  : scope.managedProductList
    }
, Apps.Merchant.RouterBase
