scope = logics.metroHome

lemon.defineApp Template.geraHome,
#  revenueDay: -> @Summary.data.salesMoneyDay - @Summary.data.importMoneyDay + @Summary.data.returnMoneyOfDistributorDay - @Summary.data.returnMoneyOfCustomerDay
#  merchantReportLock: -> @Summary.data.customerCount + @Summary.data.distributorCount
  rendered: ->
#    console.log('starting tour...')
#    Apps.currentTour.init()
#
#    if !Session.get('mySession')?.tourDisabled
#      Apps.currentTour.restart()
#      UserSession.set('tourDisabled', true)
#
  events:
    "click [data-app]:not(.locked)": (event, template) -> Router.go $(event.currentTarget).attr('data-app')