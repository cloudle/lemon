lemon.defineApp Template.merchantHome,
  events:
    "click [data-app]:not(.locked)": (event, template) -> Router.go $(event.currentTarget).attr('data-app')