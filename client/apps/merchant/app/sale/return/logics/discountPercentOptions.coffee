Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.discountPercentOptions =
    reactiveSetter: (val) ->
      option = {discountPercent : val}
      if val > 0 then option.discountCash = Math.round((Session.get('currentReturn').totalPrice)/100*val)
      else option.discountCash = 0

      option.finallyPrice = Session.get('currentReturn').totalPrice - option.discountCash
      Schema.returns.update(Session.get('currentReturn')._id, {$set: option}) if Session.get('currentReturn')
    reactiveValue: -> Math.round(Session.get('currentReturn')?.discountPercent) ? 0
    reactiveMax: -> 100
    reactiveMin: -> 0
    reactiveStep: -> 1
