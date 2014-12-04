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
  data: ->
#    Apps.setup(scope, Apps.Merchant.merchantReportReactive)
    return {
      branchList: Schema.merchants.find
        $or: [{_id: Session.get('myProfile')?.parentMerchant}, {parent: Session.get('myProfile')?.parentMerchant}]
    }
, Apps.Merchant.RouterBase