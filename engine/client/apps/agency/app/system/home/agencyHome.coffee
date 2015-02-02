scope = logics.metroAgencyHome

lemon.defineApp Template.agencyHome,
  events:
    "click [data-app]:not(.locked)": (event, template) -> Router.go $(event.currentTarget).attr('data-app')