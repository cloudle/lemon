scope = logics.metroHome

lemon.addRoute
  template: 'geraHome'
  path: 'gera'
  waitOnDependency: 'merchantHome'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Gera.homeInit, 'geraHome')
      Session.set "currentAppInfo",
        name: "gera"
      @next()
  data: -> {
    Summary: MetroSummary.findOne({})
  }
, Apps.Merchant.RouterBase