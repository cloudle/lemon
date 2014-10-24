merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('essentials')
  data: -> { System: System.findOne({}) }

metroSummaryRoute =
  layoutTemplate: 'merchantLayout',
  template: 'metroHome',
  fastRender: true,
  waitOn: -> lemon.dependencies.resolve('metroHome')
  data: -> {Summary: MetroSummary.findOne({})}

lemon.addRoute [merchantDevRoute, metroSummaryRoute]