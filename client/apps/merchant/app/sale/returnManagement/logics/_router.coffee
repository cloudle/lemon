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
      tabOptions                 : scope.tabOptions
      returnSelectOptions        : scope.returnSelectOptions
      distributorSelectOptions   : scope.distributorSelectOptions
      customerSelectOptions      : scope.customerSelectOptions
      allReturnProduct           : scope.managedReturnProductList

    }

lemon.addRoute [returnManagementRoute], Apps.Merchant.RouterBase