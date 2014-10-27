merchantRouteBase =
  layoutTemplate: 'merchantLayout'
  fastRender: true
  onAfterAction: ->
    Helpers.animateUsing("#container", "bounceInDown")

merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('essentials')
  data: -> { System: System.findOne({}) }
_.extend(merchantDevRoute, merchantRouteBase)

metroSummaryRoute =
  template: 'merchantHome'
  path: 'merchant'
  waitOn: -> lemon.dependencies.resolve('merchantHome', Merchant.Subscriber)
  data: -> {Summary: MetroSummary.findOne({})}
_.extend(metroSummaryRoute, merchantRouteBase)

saleRoute =
  template: 'sales'
  waitOn: -> lemon.dependencies.resolve('metroHome')
  data: -> {Summary: MetroSummary.findOne({})}
_.extend(saleRoute, merchantRouteBase)

lemon.addRoute [merchantDevRoute, metroSummaryRoute]