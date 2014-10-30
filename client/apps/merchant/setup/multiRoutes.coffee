merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('essentials')
  data: -> { System: System.findOne({}) }
_.extend(merchantDevRoute, Apps.Merchant.RouterBase)

metroSummaryRoute =
  template: 'merchantHome'
  path: 'merchant'
  waitOn: -> lemon.dependencies.resolve('merchantHome', Apps.MerchantSubscriber)
  data: -> {Summary: MetroSummary.findOne({})}
_.extend(metroSummaryRoute, Apps.Merchant.RouterBase)

lemon.addRoute [merchantDevRoute, metroSummaryRoute]