merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('dep1')
  data: -> { }

metroSummaryRoute =
  layoutTemplate: 'merchantLayout',
  template: 'metroHome',
  fastRender: true,
  waitOn: -> lemon.dependencies.resolve('metroHome')
  data: -> {Summary: MetroSummary.findOne({})}

lemon.addRoute [merchantDevRoute, metroSummaryRoute]