lemon.defineApp Template.merchantHome,
  revenueDay: -> @Summary.salesMoneyDay - @Summary.importMoneyDay + @Summary.returnMoneyOfDistributorDay - @Summary.returnMoneyOfCustomerDay
  events:
    "click [data-app]:not(.locked)": (event, template) -> Router.go $(event.currentTarget).attr('data-app')
    "click .caption.inner": -> Router.go @app