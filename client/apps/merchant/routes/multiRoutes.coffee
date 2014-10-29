merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('essentials')
  data: -> { System: System.findOne({}) }
_.extend(merchantDevRoute, Merchant.merchantRouteBase)

metroSummaryRoute =
  template: 'merchantHome'
  path: 'merchant'
  waitOn: -> lemon.dependencies.resolve('merchantHome', Merchant.Subscriber)
  data: -> {Summary: MetroSummary.findOne({})}
_.extend(metroSummaryRoute, Merchant.merchantRouteBase)

#importRoute =
#  layoutTemplate: 'merchantLayout',
#  template: 'import',
#  fastRender: true,
#  waitOn: -> lemon.dependencies.resolve('import')
#  data: ->
#    logics.sales.syncMyProfile()
#    logics.sales.syncMyOption()
#    logics.sales.syncMySession()
#
#    return{
#
#    }
#_.extend(saleRoute, Merchant.merchantRouteBase)



lemon.addRoute [merchantDevRoute, metroSummaryRoute]