scope = logics.merchantHome

lemon.defineApp Template.merchantHome,
  revenueDay: -> @Summary.data.salesMoneyDay - @Summary.data.importMoneyDay + @Summary.data.returnMoneyOfDistributorDay - @Summary.data.returnMoneyOfCustomerDay
  rendered: ->
    console.log('starting tour...')
    Apps.currentTour.init()

    if !Session.get('mySession')?.tourDisabled
      Apps.currentTour.restart()
      UserSession.set('tourDisabled', true)

  events:
    "click [data-app]:not(.locked)": (event, template) -> Router.go $(event.currentTarget).attr('data-app')