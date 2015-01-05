scope = logics.distributorReturn

distributorReturnRoute =
  template: 'distributorReturn',
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.distributorReturnInit, 'distributorReturn')
      Session.set "currentAppInfo",
        name: "trả hàng"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.distributorReturnReactiveRun)

    return {
      tabOptions               : scope.tabOptions
      distributorSelectOptions : scope.distributorSelectOptions
      allReturnProduct         : scope.managedReturnProductList

    }

lemon.addRoute [distributorReturnRoute], Apps.Merchant.RouterBase