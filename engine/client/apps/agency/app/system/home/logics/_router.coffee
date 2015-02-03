scope = logics.metroAgencyHome

lemon.addRoute
  template: 'agencyHome'
  path: 'agency'
  waitOnDependency: 'merchantHome'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Agency.homeInit, 'agencyHome')
      Session.set "currentAppInfo",
        name: "agency"
      @next()
  data: -> {
    Summary: MetroSummary.findOne({})
  }
, Apps.Merchant.RouterBase