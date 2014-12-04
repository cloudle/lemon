scope = logics.merchantReport
lemon.addRoute
  template: 'merchantReport'
  waitOnDependency: 'merchantReport'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.merchantReportInit, 'merchantReport')
      Session.set "currentAppInfo",
        name: "báo cáo"
      @next()
#  data: ->
#    Apps.setup(scope, Apps.Merchant.merchantReportReactive)
, Apps.Merchant.RouterBase