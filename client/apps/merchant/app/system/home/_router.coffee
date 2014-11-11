metroSummaryRoute =
  template: 'merchantHome'
  path: 'merchant'
  waitOn: -> lemon.dependencies.resolve('merchantHome', Apps.MerchantSubscriber)
  onBeforeAction: ->
#    Schema.
#    @next()
  data: -> {Summary: MetroSummary.findOne({})}

lemon.addRoute [metroSummaryRoute], Apps.Merchant.RouterBase