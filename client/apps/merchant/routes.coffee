merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('essentials')
  data: -> { System: System.findOne({}) }

metroSummaryRoute =
  layoutTemplate: 'merchantLayout'
  template: 'merchantHome'
  path: 'merchant'
  fastRender: true
  waitOn: -> lemon.dependencies.resolve('merchantHome', Merchant.Subscriber)
  data: -> {Summary: MetroSummary.findOne({})}

saleRoute =
  layoutTemplate: 'merchantLayout'
  template: 'sales'
  fastRender: true
  waitOn: -> lemon.dependencies.resolve('metroHome')
  data: -> {Summary: MetroSummary.findOne({})}

lemon.addRoute [merchantDevRoute, metroSummaryRoute]