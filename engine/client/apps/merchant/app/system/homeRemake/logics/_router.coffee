scope = logics.merchantHome

lemon.addRoute
  template: 'merchantHomeRemake'
  waitOnDependency: 'merchantHome'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.homeInit, 'merchantHome')
      Session.set "currentAppInfo",
        name: ""
      @next()
  data: -> {
    Summary: MetroSummary.findOne({})
  }
, Apps.Merchant.RouterBase