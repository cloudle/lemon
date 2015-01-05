lemon.addRoute
  template: 'merchantTest'
  waitOnDependency: 'merchantTest'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.merchantTest, Apps.Merchant.testInit, 'merchantTest')
      @next()
, Apps.Merchant.RouterBase