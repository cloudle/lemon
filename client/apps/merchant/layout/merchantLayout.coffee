toggleCollapse = -> Session.set 'collapse', if Session.get('collapse') is 'collapsed' then '' else 'collapsed'

lemon.defineWidget Template.merchantLayout,
  collapse: -> Session.get('collapse') ? ''
  rendered: ->
    $(window).resize -> Helpers.arrangeAppLayout()
    Helpers.animateUsing("#container", "bounceInDown")
  events:
    "click .collapse-toggle": -> toggleCollapse()