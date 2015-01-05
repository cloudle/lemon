Apps.Merchant.RouterBase =
  layoutTemplate: 'merchantLayout'
  loadingTemplate: 'silentLoadingLayout'
  fastRender: true
  onAfterAction: ->
    Helpers.animateUsing("#container", 'fadeInDown')
    Apps.currentTour?.end()