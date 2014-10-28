Merchant.merchantRouteBase =
  layoutTemplate: 'merchantLayout'
  fastRender: true
  onAfterAction: ->
    Helpers.animateUsing("#container", "bounceInDown")