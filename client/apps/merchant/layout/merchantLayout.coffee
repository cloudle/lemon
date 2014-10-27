toggleCollapse = -> Session.set 'collapse', if Template.merchantLayout.collapse() then '' else 'collapsed'

lemon.defineWidget Template.merchantLayout,
  collapse: -> Session.get('collapse') ? 'collapsed'
  events:
    "click .collapse-toggle": -> toggleCollapse()