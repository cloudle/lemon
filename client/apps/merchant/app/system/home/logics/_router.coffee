scope = logics.merchantHome

lemon.addRoute
  template: 'merchantHome'
  path: 'merchant'
  waitOnDependency: 'merchantHome'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.homeInit, 'merchantHome')
      Session.set "currentAppInfo",
        name: "tổng quan"
      @next()
  data: -> {
    Summary: MetroSummary.findOne({})
  }
, Apps.Merchant.RouterBase