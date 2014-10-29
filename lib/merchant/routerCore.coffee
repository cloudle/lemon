Apps.Merchant.RouterBase =
  layoutTemplate: 'merchantLayout'
  fastRender: true
  onAfterAction: ->
    Helpers.animateUsing("#container", "bounceInDown")