scope = logics.geraProductGroup
lemon.addRoute
  template: 'geraProductGroup'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Gera.geraProductGroupInit, 'geraProductGroup')
      Session.set "currentAppInfo",
        name: "nhóm sản phẩm"
        navigationPartial:
          template: "geraProductGroupNavigationPartial"
          data: {}
      @next()
  data: ->
    Apps.setup(scope, Apps.Gera.geraProductGroupReactive)

    return {
      managedProductGroupList  : scope.managedProductGroupList
    }
, Apps.Merchant.RouterBase
