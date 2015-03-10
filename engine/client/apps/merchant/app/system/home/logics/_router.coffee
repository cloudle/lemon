scope = logics.merchantHome

lemon.addRoute
  path: 'merchant'
  template: 'merchantHome'
  waitOnDependency: 'merchantHome'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.homeInit, 'merchantHome')
      Session.set "currentAppInfo",
        name: "trung tâm"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.homeReactive)

    return {
      Summary : scope.summary
      Merchant: scope.merchant
      appMenus: scope.appMenus
    }
, Apps.Merchant.RouterBase