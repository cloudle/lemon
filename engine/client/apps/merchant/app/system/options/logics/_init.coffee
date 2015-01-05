logics.merchantOptions = {}
Apps.Merchant.merchantOptionsInit = []
Apps.Merchant.merchantOptionsReactive = []

scope = logics.merchantOptions

lemon.addRoute
  template: 'merchantOptions'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.merchantOptionsInit, 'customerManagement')
      Session.set "currentAppInfo",
        name: "hệ thống"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.merchantOptionsReactive)

    return {
      settings: scope.settings
    }
, Apps.Merchant.RouterBase
