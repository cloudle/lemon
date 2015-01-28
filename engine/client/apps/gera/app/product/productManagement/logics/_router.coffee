scope = logics.geraProductManagement
lemon.addRoute
  template: 'geraProductManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Gera.productManagementInit, 'geraProductManagement')
      Session.set "currentAppInfo",
        name: "sản phẩm"
        navigationPartial:
          template: "geraProductNavigationPartial"
          data: {}
      @next()
  data: ->
    Apps.setup(scope, Apps.Gera.productManagementReactive)

    return {
#      productGroupOptions : scope.productGroupSelectOptions
      managedBuildInProductList : scope.managedBuildInProductList
    }
, Apps.Merchant.RouterBase
