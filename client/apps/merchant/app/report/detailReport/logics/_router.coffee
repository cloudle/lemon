scope = logics.detailReport
lemon.addRoute
  template: 'detailReport'
  onBeforeAction: ->
    if @ready()
      Session.set "currentAppInfo",
        name: "báo cáo"
      @next()
, Apps.Merchant.RouterBase