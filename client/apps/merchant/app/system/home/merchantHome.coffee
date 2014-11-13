scope = logics.merchantHome

lemon.defineApp Template.merchantHome,
  rendered: ->
    console.log('starting tour...')
    Apps.currentTour.init()

    if !Session.get('mySession')?.tourDisabled
      Apps.currentTour.restart()
      UserSession.set('tourDisabled', true)

  events:
    "click [data-app]:not(.locked)": (event, template) -> Router.go $(event.currentTarget).attr('data-app')