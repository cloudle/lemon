scope = logics.returnManagement

returnManagementRoute =
  template: 'returnManagement',
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.returnManagementInit, 'returnManagement')
      Session.set "currentAppInfo",
        name: "trả hàng"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.returnManagementReactiveRun)

    return {
      allReturnProduct: scope.managedReturnProductList
    }

lemon.addRoute [returnManagementRoute], Apps.Merchant.RouterBase