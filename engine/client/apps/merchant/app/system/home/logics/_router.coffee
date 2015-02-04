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
  data: -> {
    Summary: MetroSummary.findOne({})
    appMenus: scope.appMenus
  }
, Apps.Merchant.RouterBase