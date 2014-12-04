Apps.Merchant.RouterBase =
  layoutTemplate: 'merchantLayout'
  loadingTemplate: 'silentLoadingLayout'
  fastRender: true
  onAfterAction: ->
    animation = if Router.current().url is '/merchant' then 'fadeInLeft' else 'fadeInDown'
    Helpers.animateUsing("#container", animation)
    Apps.currentTour?.end()